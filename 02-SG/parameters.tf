resource "aws_ssm_parameter" "Frontend_sg_id" {
  name  = "/${var.Project}/${var.Environment}/Frontend_sg_id"
  type  = "String"
  value = module.frontend.sg_id
}