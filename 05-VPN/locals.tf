locals {
  common_tags = {
    Project = var.Project
    Environment = var.Environment
    TERRAFORM = true
  }

  ami_id = data.aws_ami.openvpn.id
  VPN_sg_id = data.aws_ssm_parameter.VPN_sg_id.value
  public_subnet_id = split("," , data.aws_ssm_parameter.public_subnet_id.value)[0]

}