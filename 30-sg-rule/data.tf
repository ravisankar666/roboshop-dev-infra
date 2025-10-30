data "aws_ssm_parameter" "backend_alb_sg_id" {
    name = "/${var.project_name}/${var.environment}/backend_alb_sg_id"
}