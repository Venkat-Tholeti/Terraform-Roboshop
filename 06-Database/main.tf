resource "aws_instance" "MongoDb" {
  ami  = local.ami_id
  instance_type = "t3.micro"
  vpc_security_group_ids  = [local.MongoDb_sg_id]
  subnet_id = local.database_subnet_id

  tags = merge(
    local.common_tags,
  {
    Name = "${var.Project}-${var.Environment}-MongoDb"
  }
  )
}

#Our goal is to connect to infra and install what we need. So we are using terraform data (formerly null resource) and triggers for that.
resource "terraform_data" "MongoDb" {
  triggers_replace = [
    aws_instance.MongoDb.id
  ]
  
  provisioner "file" {
    source      = "bootstrap.sh"
    destination = "/tmp/bootstrap.sh"
  }


 connection {
    type     = "ssh"
    user     = "ec2-user"
    password = "DevOps321"
    host     = aws_instance.MongoDb.private_ip
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/bootstrap.sh",
      "sudo sh /tmp/bootstrap.sh mongodb"
    ]
  }

}