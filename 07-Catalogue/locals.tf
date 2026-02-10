locals {
  common_tags = {
    Project = var.Project
    Environment = var.Environment
    TERRAFORM = true
  }
  
  ami_id = data.aws_ami.joindevops.id
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  private_subnet_id = data.aws_ssm_parameter.private_subnet_id.value
  Catalogue_sg_id = data.aws_ssm_parameter.Catalogue_sg_id.value
}



