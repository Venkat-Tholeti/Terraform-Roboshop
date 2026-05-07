#THIS IS OPEN SOURCE MODULE FROM TERRAFORM NOT CUSTOMISED BY US

module "Internal_ALB" {
  source = "terraform-aws-modules/alb/aws"
  version = "9.16.0" # As our given provider version does not support this module we are giving the supported version to this module here
  internal = true
  name    = "${var.project}-${var.environment}-Internal-ALB"
  vpc_id  = local.vpc_id
  subnets = local.private_subnet_ids
  create_security_group = false
  security_groups = [local.Internal_ALB_sg_id]
 
  
  tags = merge(
    local.common_tags,
    {
        Name = "${var.project}-${var.environment}-Internal_ALB"
    }
  )
}

resource "aws_lb_listener" "Internal_ALB" {
  load_balancer_arn = module.Internal_ALB.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "<h1> Hello, I am From Internal ALB"
      status_code  = "200"
    }
  }
}