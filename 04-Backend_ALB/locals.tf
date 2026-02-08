locals {
  common_tags = {
    Project = var.Project
    Environment = var.Environment
    TERRAFORM = true
  }
  
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  private_subnet_id = split("," , data.aws_ssm_parameter.public_subnet_id.value)
  backend_alb_sg_id = data.aws_ssm_parameter.Backend_ALB_sg_id.value
}

