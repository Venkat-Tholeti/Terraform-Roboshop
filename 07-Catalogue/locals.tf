locals {
  common_tags = {
    Project = var.Project
    Environment = var.Environment
    TERRAFORM = true
  }
  
  ami_id = data.aws_ami.joindevops.id
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  private_subnet_id = split ("," , data.aws_ssm_parameter.private_subnet_ids.value)[0]
  private_subnet_ids = split ("," , data.aws_ssm_parameter.private_subnet_ids.value)
  Catalogue_sg_id = data.aws_ssm_parameter.Catalogue_sg_id.value
  backend_alb_listener_arn = data.aws_ssm_parameter.backend_alb_listener_arn.value
}



