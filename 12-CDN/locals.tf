locals {
    vpc_id = data.aws_ssm_parameter.vpc_id.value

    private_subnet_id = split ("," , data.aws_ssm_parameter.private_subnet_ids.value)[0]
    private_subnet_ids = split ("," , data.aws_ssm_parameter.private_subnet_ids.value)

    backend_alb_listener_arn = data.aws_ssm_parameter.Backend_ALB_listener_arn.value
    frontend_alb_listener_arn = data.aws_ssm_parameter.Frontend_alb_listener_arn.value

    ami_id = data.aws_ami.joindevops.id
    sg_id = data.aws_ssm_parameter.sg_id.value

    alb_listener_arn = "${var.Component}" == "frontend" ? local.frontend_alb_listener_arn : local.backend_alb_listener_arn

    tg_port = "${var.Component}" == "frontend" ? 80 : 8080
    health_check_path = "${var.Component}" == "frontend" ? "/" : "/health"

    rule_header_url = "${var.Component}" == "frontend" ? "${var.Environment}.${var.zone_name}" : "${var.Component}.backend-${var.Environment}.${var.zone_name}"

    common_tags = {
        Project = var.Project
        Environment = var.Environment
        Terraform = "true"
    }
}