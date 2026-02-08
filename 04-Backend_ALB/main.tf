module "Backend_ALB" {
  source = "terraform-aws-modules/alb/aws"
  version = "v10.5.0" # AS our harshicorp ersion is not suitable to rfer terraform owned module we are giving version by checking the terraform owned module github tags setion 
  internal = true #BY default terraform owned modules have public lb config, so we need to change it to private lb config as we are creating priavte lb.
  name    = "${var.Project}-${var.Environment}-Backend-ALB"
  vpc_id  = local.vpc_id
  subnets = local.private_subnet_id
  create_security_group = false # As we already created the security group, we need to keep it as false
  security_groups = [local.backend_alb_sg_id]

  tags = merge(
    local.common_tags,
    {
        Name = "${var.Project}-${var.Environment}-Backend-ALB"
    }
  )
}