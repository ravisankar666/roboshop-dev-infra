resource "aws_security_group_rule" "frontend_frontend_alb" {
  type              = "ingress"
  security_group_id = local.backend_alb_sg_id # frontend SG ID
  source_security_group_id = module.sg[11].sg_id # frontend ALB SG ID
  from_port         = 80
  protocol          = "tcp"
  to_port           = 80
}

resource "aws_security_group_rule" "bastion_laptop" {
  type              = "ingress"
  security_group_id = local.bustion_sg_id 
  source_security_group_id = 
  from_port         = 80
  protocol          = "tcp"
  to_port           = 80
}