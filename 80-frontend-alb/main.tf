resource "aws_lb" "test" {
  name               =  "${local.common_name_suffix}-frontend-alb"

  internal           = false
  load_balancer_type = "application"
  security_groups    = [local.frontend_alb_name]
  subnets            = local.public_subnet_ids

  enable_deletion_protection = true

  tags = merage(
    local.common_tags,
    {
        Name = "${local.common_name_suffix}-frontend-alb"
    }
  )

} 

