resource "aws_ssm_parameter" "vpc_id" {
  name  = "/${var.Project}/${var.Environment}/vpc_id"
  type  = "String"
  value = module.vpc.vpc_id
}