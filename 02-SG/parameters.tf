resource "aws_ssm_parameter" "Frontend_sg_id" {
  name  = "/${var.Project}/${var.Environment}/Frontend_sg_id"
  type  = "String"
  value = module.Frontend.sg_id
}

resource "aws_ssm_parameter" "Bastion_sg_id" {
  name  = "/${var.Project}/${var.Environment}/Bastion_sg_id"
  type  = "String"
  value = module.Bastion.sg_id
}

resource "aws_ssm_parameter" "Backend_ALB_sg_id" {
  name  = "/${var.Project}/${var.Environment}/Backend_ALB_sg_id"
  type  = "String"
  value = module.Backend_ALB.sg_id
}

resource "aws_ssm_parameter" "VPN_sg_id" {
  name  = "/${var.Project}/${var.Environment}/VPN_sg_id"
  type  = "String"
  value = module.VPN.sg_id
}

resource "aws_ssm_parameter" "MongoDb_sg_id" {
  name  = "/${var.Project}/${var.Environment}/MongoDb_sg_id"
  type  = "String"
  value = module.MongoDb.sg_id
}