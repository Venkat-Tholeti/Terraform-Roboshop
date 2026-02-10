resource "aws_ssm_parameter" "backend_alb_listener_arn" {
  name  = "/${var.Project}/${var.Environment}/backend_alb_listener_arn"
  type  = "String"
  value = aws_lb_listener.backend_alb.arn
}