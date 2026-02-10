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