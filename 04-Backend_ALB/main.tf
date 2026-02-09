module "Backend_ALB" {
  source = "terraform-aws-modules/alb/aws"
  version = "v10.5.0" # AS our harshicorp version is not suitable to rfer terraform owned module we are giving version by checking the terraform owned module github tags setion 
  internal = true #BY default terraform owned modules have public lb config, so we need to change it to private lb config as we are creating priavte lb.
  name    = "${var.Project}-${var.Environment}-Backend-ALB"
  vpc_id  = local.vpc_id
  subnets = local.private_subnet_id
  create_security_group = false # As we already created the security group, we need to keep it as false
  security_groups = [local.backend_alb_sg_id]
  enable_deletion_protection = false

  tags = merge(
    local.common_tags,
    {
        Name = "${var.Project}-${var.Environment}-Backend-ALB"
    }
  )
}


#Configuring Listener

resource "aws_lb_listener" "Backend_ALB" {
  load_balancer_arn = module.Backend_ALB.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/html"
      message_body = "<h1>Hello, I Am From Backend ALB<h1>"
      status_code  = "200"
    }
  }
}


resource "aws_route53_record" "Backend_ALB" {
  zone_id = var.zone_id
  name    = "*.backend-dev.${var.zone_name}"
  type    = "A"

  alias {
    name                   = module.Backend_ALB.dns_name
    zone_id                = module.Backend_ALB.zone_id #This is the Zone id of ALB not Route 53
    evaluate_target_health = true
  }
}