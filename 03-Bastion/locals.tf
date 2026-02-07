locals {
  ami_id = data.aws_ami.joindevops.id
  Bastion_sg_id = data.aws_ssm_parameter.Bastion_sg_id.value
}
