locals {
  ami_id = data.aws_ami.OpenVPN.id
  vpn_sg_id = data.aws_ssm_parameter.vpn_sg_id.value
  public_subnet_ids = split(",", data.aws_ssm_parameter.public_subnet_ids.value)[0] #refer class 39 @45th minute
}

locals {
  common_tags = {
    project = var.project
    environment = var.environment
    terraform = "true"
  }
}