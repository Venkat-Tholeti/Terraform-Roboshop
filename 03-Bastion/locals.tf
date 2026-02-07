locals {
  common_tags = {
    Project = var.Project
    Environment = var.Environment
    TERRAFORM = true
  }

  ami_id = data.aws_ami.joindevops.id
  Bastion_sg_id = data.aws_ssm_parameter.Bastion_sg_id.value
  public_subnet_id = split("," , data.aws_ssm_parameter.public_subnet_id.value)[0]

}