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

    provisioner "remote-exec" {
      
    }






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
    # terraform copies this file to mongodb server
    provisioner "file" {
        source = "bootstrap.sh"
        destination = "/tmp/bootstrap.sh"
      
    }

  provisioner "remoto-exec" {
    inline = [
        "chmod +x /tmp/bootstrap.sh",
        "sudo sh  /tmp/bootstrap.sh"
    ]
  }
}

