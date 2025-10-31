locals {
  ami_id = data.aws_ami.devsecops.id
  bastion_sg_id  = data.aws_ssm_parameter.bastion_sg_id.value
  public_subent_id = split("," , data.aws_ssm_parameter.public_subnet_ids.value )[0]
  common_tags = {
    Project = var.project_name
    Environment = var.environment
    Terraform = true
  }

}