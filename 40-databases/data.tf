data "aws_ssm_parameter" "vpc_id" {
  name = "/${var.project_name}/${var.environment}/database"
}

data "aws_ami" "devsecops" {
    owners   = ["517542309828"]
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

data "aws_ssm_parameter" "database_subnet_ids" {
  name = "/${var.project_name}/${var.environment}/database_subnet_ids"

}

