locals {
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  private_subnet_ids = split(",", data.aws_ssm_parameter.private_subnet_ids.value)
  Internal_ALB_sg_id = data.aws_ssm_parameter.Internal_ALB_sg_id.value
}

locals {
  common_tags = {
    project = var.project
    environment = var.environment
    terraform = "true"
  }
}