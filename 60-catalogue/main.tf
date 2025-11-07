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
  
}
