# using open source module
# module "vote_service_sg" {
#     source = "terraform-aws-modules/security-group/aws"

#     name = "${local.common_name_suffix}-catalogue"
#     description = "security group for catalogue with custom ports open within VPC,egress all traffic"
#     vpc_id = data.aws_ssm_parameter.vpc_id.value

# }    
    

    module "sg" {
        count =length(var.sg_names)
       source = "../../terraform-aws-sg"
        project_name = var.project_name
        environment = var.environment
        sg_name = var.sg_names[count.index]
        sg_description = "created for ${var.sg_names[count.index]}"
        vpc_id =  local.vpc_id
      
    }

# Frontend accepting traffic from frontend ALB
# resource "aws_security_group_rule" "frontend_frontend_alb" {
#   type              = "ingress"
#   security_group_id = module.sg[9].sg_id # frontend SG ID
#   source_security_group_id = module.sg[11].sg_id # frontend ALB SG ID
#   from_port         = 80
#   protocol          = "tcp"
#   to_port           = 80
# }