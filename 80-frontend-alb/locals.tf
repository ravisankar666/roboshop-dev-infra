locals {
    common_name_suffix = "${var.project_name}-${var.environment}"
    common_tags = {
        Project = var.project_name
        Environment = var.environment
        Terraform = "true"
    }
    frontend_alb_name  = data.aws_ssm_parameter.frontend_alb_sg_id.value
    public_subnet_ids = split(",", data.aws_ssm_parameter.public_subnet_ids.value)  
    
}