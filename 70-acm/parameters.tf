resource "aws_ssm_parameter" "forntend_alb_certificate_arn" {
  name  = "/${var.project_name}/${var.environment}/frontend-alb/certificate-arn"
  type  = "String"
  value = aws_acm_certificate.roboshop.arn

}