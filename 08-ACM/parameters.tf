resource "aws_ssm_parameter" "acm_certificate_arn" {
  name  = "/${var.Project}/${var.Environment}/acm_certificate_arn"
  type  = "String"
  value = aws_acm_certificate.daws84s.arn
}