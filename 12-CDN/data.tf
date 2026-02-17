data "aws_ssm_parameter" "vpc_id" {
  name = "/${var.Project}/${var.Environment}/vpc_id"
}

data "aws_ssm_parameter" "private_subnet_ids" {
  name = "/${var.Project}/${var.Environment}/private_subnet_ids"
}

data "aws_ssm_parameter" "sg_id" {
  name = "/${var.Project}/${var.Environment}/${var.Component}_sg_id"
}

data "aws_ssm_parameter" "Backend_ALB_listener_arn" {
  name = "/${var.Project}/${var.Environment}/backend_alb_listener_arn"
}

data "aws_ssm_parameter" "Frontend_alb_listener_arn" {
  name = "/${var.Project}/${var.Environment}/frontend_alb_listener_arn"
}

data "aws_ami" "joindevops" {
  owners           = ["973714476881"]
  most_recent      = true

  filter {
    name   = "name"
    values = ["Redhat-9-DevOps-Practice"]
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