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