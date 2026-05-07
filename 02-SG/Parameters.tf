resource "aws_ssm_parameter" "frontend_sg_id" {
  name        = "/${var.project}/${var.environment}/frontend_sg_id"
  type        = "String"
  value       = module.frontend.sg_id
}

resource "aws_ssm_parameter" "bastion_sg_id" {
  name        = "/${var.project}/${var.environment}/bastion_sg_id"
  type        = "String"
  value       = module.bastion.sg_id
}

resource "aws_ssm_parameter" "Internal_ALB_sg_id" {
  name        = "/${var.project}/${var.environment}/Internal_ALB_sg_id"
  type        = "String"
  value       = module.Internal_ALB.sg_id
}

resource "aws_ssm_parameter" "vpn_sg_id" {
  name        = "/${var.project}/${var.environment}/vpn_sg_id"
  type        = "String"
  value       = module.vpn.sg_id
}

resource "aws_ssm_parameter" "mongodb_sg_id" {
  name        = "/${var.project}/${var.environment}/mongodb_sg_id"
  type        = "String"
  value       = module.mongodb.sg_id
}