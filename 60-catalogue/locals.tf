locals {
  common_name_suffix = "${var.project_name}-${var.environment}" #roboshop-dev
  catalogue_sg_id = data.aws_ssm_parameter.catalogue_sg_id.value
  vpc_id = data.aws_ssm_parameter.vpc_id.value
 

  private_subent_id = split("," , data.aws_ssm_parameter.private_subnet_id.value )[0]
  ami_id = data.aws_ami.devsecops.id
  common_tags = {
    Project = var.project_name
    Environment = var.environment
    Terraform = "true"

  }

} 