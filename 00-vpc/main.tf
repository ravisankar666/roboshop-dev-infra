module "vpc" {
    #refer terraform module form github -real_time
    # source  = "../terraform-aws-vpc"

    source = "git::https://github.com/ravisankar666/terraform-aws-vpc.git?ref=main"
    #vpc
    vpc_cidr = var.vpc_cidr
    project_name = var.project_name
    environment = var.environment
    vpc_tags = var.vpc_tags
    #public subnet
    public_subnet_cidrs = var.public_subnet_cidrs

    #private subnet

    private_subnet_cidrs = var.private_subnet_cidrs

    #database_subnet
    database_subnet_cidrs = var.database_subnet_cidrs

    is_peering_required = true

}
# data "aws_availability_zone" "available" {
#     state = "available"
# }