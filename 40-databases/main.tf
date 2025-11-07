 resource "aws_instance" "mongodb" {
    ami = local.ami_id
    instance_type = "t3.micro"
    vpc_security_group_ids = [local.mongodb_sg_id]
    subnet_id = local.database_subent_ids
    tags = merge(
        local.common_tags,
        {
            Name = "${local.common_name_suffix}-mongodb" #roboshop-dev-mongodb
        }
    )

   
}

resource "terraform_data" "mongodb" {
  triggers_replace = [
    aws_instance.mongodb.id,
    aws_instance.database.id
  ]

  connection {                   #connection block , try to connect ec2-instance
      type = "ssh"
      user = "ec2-user"
      password = "DevOps321"
      host = aws.instance.mongodb.private_ip
    }
    # terraform copies this file to mongodb server                      provisioner excutes either creatation-time or destroy-time
    provisioner "file" {
        source = "bootstrap.sh"
        destination = "/tmp/bootstrap.sh"
      
    }

  provisioner "remoto-exec" {
    inline = [
        "chmod +x /tmp/bootstrap.sh",
        # "sudo sh  /tmp/bootstrap.sh "
        "sudo sh  /tmp/bootstrap.sh mongodb"
    ]
  }
}
#redis
resource "aws_instance" "redis" {
    ami = local.ami_id
    instance_type = "t3.micro"
    vpc_security_group_ids = [local.redis_sg_id]
    subnet_id = local.database_subent_ids
    tags = merge(
        local.common_tags,
        {
            Name = "${local.common_name_suffix}-redis" #roboshop-dev-redis
        }
    )

   
}

resource "terraform_data" "redis" {
  triggers_replace = [
    aws_instance.redis.id,
    aws_instance.database.id
  ]

  connection {                   #connection block , try to connect ec2-instance
      type = "ssh"
      user = "ec2-user"
      password = "DevOps321"
      host = aws.instance.redis.private_ip
    }
    # terraform copies this file to redis server                      provisioner excutes either creatation-time or destroy-time
    provisioner "file" {
        source = "bootstrap.sh"
        destination = "/tmp/bootstrap.sh "
      
    }

  provisioner "remoto-exec" {
    inline = [
        "chmod +x /tmp/bootstrap.sh",
        "sudo sh  /tmp/bootstrap.sh redis"
    ]
  }
}

#rabbitmq
resource "aws_instance" "rabbitmq" {
    ami = local.ami_id
    instance_type = "t3.micro"
    vpc_security_group_ids = [local.rabbitmq_sg_id]
    subnet_id = local.database_subent_ids
    tags = merge(
        local.common_tags,
        {
            Name = "${local.common_name_suffix}-rabbitmq" #roboshop-dev-rabbitmq
        }
    )

   
}

resource "terraform_data" "rabbitmq" {
  triggers_replace = [
    aws_instance.rabbitmq.id,
    aws_instance.database.id
  ]

  connection {                   #connection block , try to connect ec2-instance
      type = "ssh"
      user = "ec2-user"
      password = "DevOps321"
      host = aws.instance.rabbitmq.private_ip
    }
    # terraform copies this file to rabbitmq server                      provisioner excutes either creatation-time or destroy-time
    provisioner "file" {
        source = "bootstrap.sh"
        destination = "/tmp/bootstrap.sh "
      
    }

  provisioner "remoto-exec" {
    inline = [
        "chmod +x /tmp/bootstrap.sh",
        "sudo sh  /tmp/bootstrap.sh rabbitmq"
    ]
  }
}


#mysql
resource "aws_instance" "mysql" {
    ami = local.ami_id
    instance_type = "t3.micro"
    vpc_security_group_ids = [local.mysql_sg_id]
    subnet_id = local.database_subent_ids
    iam_instance_profile = aws_iam_instance_profile.mysql.name
    tags = merge(
        local.common_tags,
        {
            Name = "${local.common_name_suffix}-mysql" #roboshop-dev-mysql
        }
    )

   
}

resource "aws_iam_instance_profile" "mysql" {
  name = "mysql"
  role = "EC2SSMParameter"
}


resource "terraform_data" "mysql" {
  triggers_replace = [
    aws_instance.mysql.id,
    aws_instance.database.id
  ]

  connection {                   #connection block , try to connect ec2-instance
      type = "ssh"
      user = "ec2-user"
      password = "DevOps321"
      host = aws.instance.mysql.private_ip
    }
    # terraform copies this file to mysql server                      provisioner excutes either creatation-time or destroy-time
    provisioner "file" {
        source = "bootstrap.sh"
        destination = "/tmp/bootstrap.sh "
      
    }

  provisioner "remoto-exec" {
    inline = [
        "chmod +x /tmp/bootstrap.sh",
        "sudo sh  /tmp/bootstrap.sh mysql"
    ]
  }
}




resource "aws_route53_record" "mongodb" {
  zone_id = var.zone-id
  name    = "mongodb-${var.environment}.${var.domain_name}" #monodb-dev.daws86.fun
  type    = "A"
  ttl     = 1
  records = [aws_instance.mongodb.private_ip]
  allow_overwrite = true
}

resource "aws_route53_record" "redis" {
  zone_id = var.zone-id
  name    = "redis-${var.environment}.${var.domain_name}" #redis-dev.daws86.fun
  type    = "A"
  ttl     = 1
  records = [aws_instance.redis.private_ip]
  allow_overwrite = true
}
resource "aws_route53_record" "mysql" {
  zone_id = var.zone-id
  name    = "mysql-${var.environment}.${var.domain_name}" #mysql-dev.daws86.fun
  type    = "A"
  ttl     = 1
  records = [aws_instance.mysql.private_ip]
  allow_overwrite = true
}
resource "aws_route53_record" "rabbitmq" {
  zone_id = var.zone-id
  name    = "rabbitmq-${var.environment}.${var.domain_name}" #rabbitmq-dev.daws86.fun
  type    = "A"
  ttl     = 1
  records = [aws_instance.rabbitmq.private_ip]
  allow_overwrite = true
}
