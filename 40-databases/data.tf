data "aws_ssm_parameter" "vpc_id" {
  name = "/${var.project_name}/${var.environment}/vpc_id"
}

data "aws_ami" "devsecops" {
    owners   = ["973714476881"]
    most_recent   = true

    filter {
      name = "name"
      values = ["RHEL-9-DevOps-Practice"]
    }

    filter {
        name = "root-device-type"
        values = ["ebs"]
      
    }

    filter {
      name = "virtualization-type"
      values = ["hvm"]
    }
}
data "aws_ssm_parameter" "mongodb_sg_id" {
  name = "/${var.project_name}/${var.environment}/mongodb_sg_id"

}

data "aws_ssm_parameter" "database_subnet_id" {
  name = "/${var.project_name}/${var.environment}/database_subnet_id"

}
data "aws_ssm_parameter" "redis_sg_id" {
  name = "/${var.project_name}/${var.environment}/redis_sg_id"

}

data "aws_ssm_parameter" "rabbitmq_sg_id" {
  name = "/${var.project_name}/${var.environment}/rabbitmq_sg_id"

}
data "aws_ssm_parameter" "mysql_sg_id" {
  name = "/${var.project_name}/${var.environment}/mysql_sg_id"

}
data "aws_ssm_parameter" "catalogue_sg_id" {
  name = "/${var.project_name}/${var.environment}/catalogue_sg_id"

}

