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
data "aws_ssm_parameter" "bastion_sg_id" {
  name = "/${var.project_name}/${var.environment}/bastion_sg_id"

}

data "aws_ssm_parameter" "public_subnet_ids" {
  name = "/${var.project_name}/${var.environment}/public_subnet_ids"

}

