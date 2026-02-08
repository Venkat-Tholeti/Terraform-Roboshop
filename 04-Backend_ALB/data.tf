data "aws_ssm_parameter" "vpc_id" {
  name = "/${var.Project}/${var.Environment}/vpc_id"
}

data "aws_ssm_parameter" "private_subnet_id" {
  name  = "/${var.Project}/${var.Environment}/private_subnet_id"
}

data "aws_ssm_parameter" "Backend_ALB_sg_id" {
  name  = "/${var.Project}/${var.Environment}/Backend_ALB_sg_id"
}
