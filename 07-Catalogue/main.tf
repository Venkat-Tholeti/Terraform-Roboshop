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
  
  tags = merge(
    local.common_tags,
  {
    Name = "${var.Project}-${var.Environment}-Catalogue"
  }
  )
}

#Our goal is to connect to infra and install what we need. So we are using terraform data (formerly null resource) and triggers for that.
resource "terraform_data" "Catalogue" {
  triggers_replace = [
    aws_instance.Catalogue.id
  ]
  
  provisioner "file" {
    source      = "catalogue.sh"
    destination = "/tmp/catalogue.sh"
  }


 connection {
    type     = "ssh"
    user     = "ec2-user"
    password = "DevOps321"
    host     = aws_instance.Catalogue.private_ip
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/catalogue.sh",
      "sudo sh /tmp/catalogue.sh catalogue"
    ]
  }

}

resource "aws_ec2_instance_state" "Catalogue" {
  instance_id = aws_instance.Catalogue.id
  state       = "stopped"
  depends_on = [ terraform_data.Catalogue ]
}

resource "aws_ami_from_instance" "Catalogue" {
  name    = "${var.Project}-${var.Environment}-Catalogue"
  source_instance_id = aws_instance.Catalogue.id
  depends_on = [ aws_ec2_instance_state.Catalogue ]

  tags = merge(
    local.common_tags,
  {
    Name = "${var.Project}-${var.Environment}-Catalogue"
  }
  )

}

resource "terraform_data" "Catalogue_Delete" {
  triggers_replace = [
    aws_instance.Catalogue.id
  ]
  
  # make sure you have aws configure in your laptop
  provisioner "local-exec" {
    command = "aws ec2 terminate-instances --instance-ids ${aws_instance.Catalogue.id}"
  }
   depends_on = [aws_ami_from_instance.Catalogue]
}

#CREATING LAUNCH TEMPLATE
resource "aws_launch_template" "Catalogue" {
  name = "${var.Project}-${var.Environment}-Catalogue"

  image_id = aws_ami_from_instance.Catalogue.id

  instance_initiated_shutdown_behavior = "terminate"

  instance_type = "t3.micro"

  vpc_security_group_ids = [local.Catalogue_sg_id]

  update_default_version = true #Each time we update, new version will become default

  tag_specifications {
    resource_type = "instance"

    tags = merge(
      local.common_tags,
    {
      Name = "${var.Project}-${var.Environment}-Catalogue"
    }
    )
  }

 tag_specifications { # WITH INSTANCE EBS WILL ALSO BE CREATED
    resource_type = "volume"

    tags = merge(
      local.common_tags,
    {
      Name = "${var.Project}-${var.Environment}-Catalogue"
    }
    )
  }


  tag_specifications { #Launch Template tags
    resource_type = "launch_template"

    tags = merge(
      local.common_tags,
    {
      Name = "${var.Project}-${var.Environment}-Catalogue"
    }
    )
  }
}

#AUTO SCALING 

resource "aws_autoscaling_group" "Catalogue" {
  name               = "${var.Project}-${var.Environment}-Catalogue"
  desired_capacity   = 1
  max_size           = 10
  min_size           = 1
  target_group_arns = [aws_lb_target_group.Catalogue.arn]
  vpc_zone_identifier  = local.private_subnet_ids
  health_check_grace_period = 90
  health_check_type         = "ELB"

  launch_template {
    id      = aws_launch_template.Catalogue.id
    version = aws_launch_template.Catalogue.latest_version
  }

  dynamic "tag" {
    for_each = merge(
      local.common_tags,
      {
        Name = "${var.Project}-${var.Environment}-Catalogue"
      }
    )
    content{
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
    
  }

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
    triggers = ["launch_template"]
  }

  timeouts{
    delete = "15m"
  }
}

#AutoScaling Policy

resource "aws_autoscaling_policy" "Catalogue" {
  name = "${var.Project}-${var.Environment}-Catalogue"
  autoscaling_group_name = aws_autoscaling_group.Catalogue.name
  policy_type            = "TargetTrackingScaling"
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 75.0
  }
}

resource "aws_lb_listener_rule" "Catalogue" {
  listener_arn = local.backend_alb_listener_arn
  priority     = 10

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.Catalogue.arn
  }

  condition {
    host_header {
      values = ["catalogue.backend-${var.Environment}.${var.zone_name}"]
    }
  }
}