resource "aws_lb_target_group" "Catalogue" {
  name     = "${var.Project}-${var.Environment}-Catalogue"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = local.vpc_id

 health_check {
    healthy_threshold = 2
    interval = 5
    matcher = "200-299"
    path = "/health"
    port = 8080
    timeout = 2
    unhealthy_threshold = 3
  }
}

resource "aws_instance" "Catalogue" {
  ami  = local.ami_id
  instance_type = "t3.micro"
  vpc_security_group_ids  = [local.Catalogue_sg_id]
  subnet_id = local.private_subnet_id
  iam_instance_profile = "TerraformEC2roleforSSM"
  tags = merge(
    local.common_tags,
  {
    Name = "${var.Project}-${var.Environment}-Catalogue"
  }
  )
}