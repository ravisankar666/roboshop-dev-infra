 #create ec2 instances
#catalogue
resource "aws_instance" "catalogue" {
    ami = local.ami_id
    instance_type = "t3.micro"
    vpc_security_group_ids = [local.catalogue_sg_id]
    subnet_id = local.private_subent_id
    tags = merge(
        local.common_tags,
        {
            Name = "${local.common_name_suffix}-catalogue" #roboshop-dev-catalogue
        }
    )

   
}
# Connect ti instance using remoto-exec provisioner through terrafrom_data
resource "terraform_data" "catalogue" {
  triggers_replace = [
    aws_instance.catalogue.id,
    aws_instance.database.id
  ]

  connection {                   #connection block , try to connect ec2-instance
      type = "ssh"
      user = "ec2-user"
      password = "DevOps321"
      host = aws.instance.catalogue.private_ip
    }
    # terraform copies this file to mysql server                      provisioner excutes either creatation-time or destroy-time
    provisioner "file" {
        source = "catalogue.sh"
        destination = "/tmp/catalogue.sh "
      
    }

  provisioner "remoto-exec" {
    inline = [
        "chmod +x /tmp/catalogue.sh",
        "sudo sh  /tmp/catalogue.sh catalogue ${var.environment}"
    ]
  }
}

#stop the instance to take image
resource "aws_ec2_instance_state" "catalogue" {                              #this piece of code stop the instance and take image
  instance_id = aws_instance.catalogue.id
  state = "stopped"
  depends_on = [ terraform_data.catalogue ]
  
}

resource "aws_ami_from_instance" "catalogue" {
  name = "${local.common_name_suffix}-catalogue-ami"
  source_instance_id = aws_instance.catalogue.id
  depends_on = [ aws_ec2_instance_state.catalogue ]
  tags = merge(
    local.common_tags,
    {
      Name = "${local.common_name_suffix}-catalogue"  #roboshop-dev-catalogue
    }
  )
}

#create lunch template in aws console.check "name" {
  

# create launch template
# template name ; roboshop-dev-catalogue
# template version ; optional
# in myaml have to select roboshop-dev-catalogue-ami
# instance type - t3.micro
# network-setting
# subnet ; roboshop-dev-priavte-us-east-1a
# zone:us-east-1a
# sg catalogue
# click on create launch template.

#creatation of target group
resource "aws_lb_target_group" "catalogue" {
  name     = "${local.common_name_suffix}-catalogue" 
  port     = 8080
  protocol = "HTTP"
  vpc_id   = local.vpc_id
  deregistration_delay = 60 # waiting period before deleting the instance{if big application 2000 to 3000 sec }
  health_check {
    healthy_threshold = 2
    interval = 10
    matcher = "200-299"
    path = "/health"
    port = 8080
    protocol = "HTTP"
    timeout = 2
    unhealthy_threshold = 2

  }
}

#launch template

resource "aws_launch_template" "catalogue" {
  name = "${local.common_name_suffix}-catalogue" 

  

  image_id = aws_ami_from_instance.catalogue.id

  instance_initiated_shutdown_behavior = "terminate"

  
  instance_type = "t3.micro"

  vpc_security_group_ids = [local.catalogue_sg_id]
  #tags attached to volume created by instances
  tag_specifications {
    resource_type = "volume"

    tags = merge(
      local.common_tags,
      {
        Name = "${local.common_name_suffix}-catalogue"
      }
    )
  }
   #tags attached to the launch template
  tags = merge(
      local.common_tags,
      {
        Name = "${local.common_name_suffix}-catalogue"
      }
    )

}


#auto scaling

resource "aws_autoscaling_group" "catalogue" {
  name                      = "${local.common_name_suffix}-catalogue" #roboshop-dev-catalogue
  max_size                  = 10
  min_size                  = 1
  health_check_grace_period = 100
  health_check_type         = "ELB"
  desired_capacity          = 1
  force_delete              = false
  launch_template {
    id = aws_launch_template.catalogue.id
    version = aws_ami_from_instance.catalogue.latest_version

  }
  vpc_zone_identifier       = local.private_subent_ids
  target_group_arns = [aws_lb_target_group.catalogue.arn]
 
  dynamic "tag" { #we will get the iterater with name as tag
    for_each = merge(
      local.common_tags,
      {
        Name ="${local.common_name_suffix}-catalogue"

      }
    )
    content{
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true

    }
    
  }

  timeouts {
    delete = "15m"
  }

  
}


# auto scaling policy's
resource "aws_autoscaling_policy" "example" {
  autoscaling_group_name = aws_autoscaling_group.catalogue.name
  name                   = "${local.common_name_suffix}-catalogue"
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 75.0
  }
}

resource "aws_lb_listener_rule" "catalogue" {
  listener_arn = local.backend_alb_listener_arn
  priority     = 10

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.catalogue.arn
  }

  condition {
    host_header {
      values = ["catalogue.backend-alb-${var.environment}.${var.domain_name}"]
    }
  }
}

resource "terraform_data" "catalogue_local" {
  triggers_replace = [
    aws_instance.catalogue.id
  ]
  
  depends_on = [aws_autoscaling_policy.catalogue]
  provisioner "local-exec" {
    command = "aws ec2 terminate-instances --instance-ids ${aws_instance.catalogue.id}"
  }
}