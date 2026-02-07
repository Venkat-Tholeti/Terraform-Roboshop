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