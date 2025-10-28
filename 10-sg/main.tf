# using open source module
# module "vote_service_sg" {
#     source = "terraform-aws-modules/security-group/aws"

#     name = "${local.common_name_suffix}-catalogue"
#     description = "security group for catalogue with custom ports open within VPC,egress all traffic"
#     vpc_id = data.aws_ssm_parameter.vpc_id.value

# }    
    

    module "sg" {
        count =length(var.sg_names)
        source = "git::https://github.com/ravisankar666/terraform-aws-sg.git?ref=main"
        project_name = var.project_name
        environment = var.environment
        sg_name = var.sg_names[count.index]
        sg_description = "Created for mongodb"
        vpc_id = local.vpc_id
      
    }