# DATA SOURCES ARE USED TO FETCH EXISTING INFRASTRUCTURE DETAILS WITHOUT CREATING THEM
# JUST FETCHING THE DETAILS, READ ONLY MODE #data = read
# ALREADY AWS LO UNA RESOURCES DETAILS FECTH CHESTHADI


data "aws_ami" "openvpn" {
  owners       = ["679593333241"]
  most_recent  = true

  filter {
    name   = "name"
    values = ["OpenVPN Access Server Community Image-8fbe3379-*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}


data "aws_ssm_parameter" "VPN_sg_id" {
  name = "/${var.Project}/${var.Environment}/VPN_sg_id"
}

data "aws_ssm_parameter" "public_subnet_id" {
  name = "/${var.Project}/${var.Environment}/public_subnet_id"
}