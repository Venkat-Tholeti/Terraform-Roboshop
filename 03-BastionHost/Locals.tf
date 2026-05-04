locals {
  ami_id = data.aws_ami.joindevops.id
  bastion_sg_id = data.aws_ssm_parameter.bastion_sg_id.value
}

locals {
  common_tags = {
    project = var.project
    environment = var.environment
    terraform = "true"
  }
}