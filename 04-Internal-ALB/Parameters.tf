resource "aws_ssm_parameter" "internal_alb_listener_arn" {
  name  = "/${var.project}/${var.environment}/internal_alb_listener_arn"
  type  = "String"
  value = aws_lb_listener.Internal_ALB.arn
}