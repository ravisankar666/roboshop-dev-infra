locals {
  common_name_suffix = "${var.project_name}-${var.environment}" #roboshop-dev
  mongodb_sg_id = data.aws_ssm_parameter.mongodb_sg_id.value

  database_subent_ids = split("," , data.aws_ssm_parameter.database_subnet_ids.value )[0]
  ami_id = data.aws_ami.devsecops.id
  common_tags = {
    Project = var.project_name
    Environment = var.environment
    Terraform = "true"

  }

}