#Set up a target group for an AWS Load Balancer. Without it, our load balancer wouldn’t know which instances or services to send traffic to
resource "aws_lb_target_group" "catalogue" {
  name     = "${var.project}-${var.environment}-catalogue"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = local.vpc_id

    health_check {
    healthy_threshold   = 2 #times
    unhealthy_threshold = 3 #times
    interval            = 5 #seconds
    timeout             = 2 #seconds
    path                = "/health"
    protocol            = "HTTP"
    port                = 8080
    matcher             = "200-299"
  }
}

#Create catalogue instance
resource "aws_instance" "catalogue" {
   ami = local.ami_id
   instance_type = var.instance_size
   vpc_security_group_ids = [local.catalogue_sg_id]
   subnet_id = local.private_subnet_ids
   
   
   tags = merge(
      local.common_tags,
      {
         Name = "${var.project}-${var.environment}-Catalogue"
      }
   )
}

#configure catalogue instance using null resource
resource "terraform_data" "catalogue" {
  triggers_replace = [
    aws_instance.catalogue.id #when instance id is changed it will trigger
  ]
  
  #Connect to instance  & COPY FILE FROM LOCAL TO instance
  provisioner "file" {
    source      = "catalogue.sh"
    destination = "/tmp/catalogue.sh"
  }

  connection {
    type     = "ssh"
    user     = "ec2-user"
    password = "DevOps321"
    host     = aws_instance.catalogue.private_ip
  }
  # Remote EXEC to connect to server and execute the script $1 is redis $2 is environment here
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/catalogue.sh",
      "sudo sh /tmp/catalogue.sh catalogue ${var.environment}"
    ]
  }
}

#STOPING THE INSTANCE FOR AMI
resource "aws_ec2_instance_state" "catalogue" {
  instance_id = aws_instance.catalogue.id
  state = "stopped"
  depends_on = [terraform_data.catalogue]
}

#TAKING AMI FROM STOPPED INSTANCE
resource "aws_ami_from_instance" "catalogue" {
  name               = "${var.project}-${var.environment}-Catalogue"
  source_instance_id = aws_instance.catalogue.id
  depends_on = [aws_ec2_instance_state.catalogue]

   tags = merge(
      local.common_tags,
      {
         Name = "${var.project}-${var.environment}-Catalogue"
      }
   )

}

#Deleting stopped catalogue instance using null resource
resource "terraform_data" "catalogue_delete" {
  triggers_replace = [
    aws_instance.catalogue.id 
  ]
  
  #Deleting the instance from outside, Make sure we ahve aws config in our laptop
  provisioner "local-exec" {
    command = "aws ec2 terminate-instances --instance-ids ${aws_instance.catalogue.id}"
  }

  depends_on = [aws_ami_from_instance.catalogue]

  }

resource "aws_launch_template" "catalogue" {
  name = "${var.project}-${var.environment}-catalogue"

  image_id = aws_ami_from_instance.catalogue.id
  instance_initiated_shutdown_behavior = "terminate"
  instance_type = "t3.micro"
  vpc_security_group_ids = [local.catalogue_sg_id]
  update_default_version = true # each time you update, new version will become default
  tag_specifications {
    resource_type = "instance"
    # EC2 tags created by ASG
    tags = merge(
      local.common_tags,
      {
        Name = "${var.project}-${var.environment}-catalogue"
      }
    )
  }

  # volume tags created by ASG
  tag_specifications {
    resource_type = "volume"

    tags = merge(
      local.common_tags,
      {
        Name = "${var.project}-${var.environment}-catalogue"
      }
    )
  }

  # launch template tags
  tags = merge(
      local.common_tags,
      {
        Name = "${var.project}-${var.environment}-catalogue"
      }
  )

}

resource "aws_autoscaling_group" "catalogue" {
  name                 = "${var.project}-${var.environment}-catalogue"
  desired_capacity   = 1
  max_size           = 10
  min_size           = 1
  target_group_arns = [aws_lb_target_group.catalogue.arn]
  vpc_zone_identifier  = local.private_subnet_ids
  health_check_grace_period = 90
  health_check_type         = "ELB"

  launch_template {
    id      = aws_launch_template.catalogue.id
    version = aws_launch_template.catalogue.latest_version
  }

  dynamic "tag" {
    for_each = merge(
      local.common_tags,
      {
        Name = "${var.project}-${var.environment}-catalogue"
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

resource "aws_autoscaling_policy" "catalogue" {
  name                   = "${var.project}-${var.environment}-catalogue"
  autoscaling_group_name = aws_autoscaling_group.catalogue.name
  policy_type            = "TargetTrackingScaling"
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 75.0
  }
}

resource "aws_lb_listener_rule" "catalogue" {
  listener_arn = local.internal_alb_listener_arn
  priority     = 10

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.catalogue.arn
  }

  condition {
    host_header {
      values = ["catalogue.internal-alb-${var.environment}.${var.zone_name}"]
    }
  }
}