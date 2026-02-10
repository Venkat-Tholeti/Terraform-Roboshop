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

resource "aws_instance" "Redis" {
  ami  = local.ami_id
  instance_type = "t3.micro"
  vpc_security_group_ids  = [local.Redis_sg_id]
  subnet_id = local.database_subnet_id

  tags = merge(
    local.common_tags,
  {
    Name = "${var.Project}-${var.Environment}-Redis"
  }
  )
}

#Our goal is to connect to infra and install what we need. So we are using terraform data (formerly null resource) and triggers for that.
resource "terraform_data" "Redis" {
  triggers_replace = [
    aws_instance.Redis.id
  ]
  
  provisioner "file" {
    source      = "bootstrap.sh"
    destination = "/tmp/bootstrap.sh"
  }


 connection {
    type     = "ssh"
    user     = "ec2-user"
    password = "DevOps321"
    host     = aws_instance.Redis.private_ip
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/bootstrap.sh",
      "sudo sh /tmp/bootstrap.sh redis"
    ]
  }

}


resource "aws_instance" "MySql" {
  ami  = local.ami_id
  instance_type = "t3.micro"
  vpc_security_group_ids  = [local.MySql_sg_id]
  subnet_id = local.database_subnet_id
  iam_instance_profile = "TerraformEC2roleforSSM"
  tags = merge(
    local.common_tags,
  {
    Name = "${var.Project}-${var.Environment}-MySql"
  }
  )
}

#Our goal is to connect to infra and install what we need. So we are using terraform data (formerly null resource) and triggers for that.
resource "terraform_data" "MySql" {
  triggers_replace = [
    aws_instance.MySql.id
  ]
  
  provisioner "file" {
    source      = "bootstrap.sh"
    destination = "/tmp/bootstrap.sh"
  }


 connection {
    type     = "ssh"
    user     = "ec2-user"
    password = "DevOps321"
    host     = aws_instance.MySql.private_ip
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/bootstrap.sh",
      "sudo sh /tmp/bootstrap.sh mysql"
    ]
  }

}



resource "aws_instance" "RabbitMq" {
  ami  = local.ami_id
  instance_type = "t3.micro"
  vpc_security_group_ids  = [local.RabbitMq_sg_id]
  subnet_id = local.database_subnet_id

  tags = merge(
    local.common_tags,
  {
    Name = "${var.Project}-${var.Environment}-RabbitMq"
  }
  )
}

#Our goal is to connect to infra and install what we need. So we are using terraform data (formerly null resource) and triggers for that.
resource "terraform_data" "RabbitMq" {
  triggers_replace = [
    aws_instance.RabbitMq.id
  ]
  
  provisioner "file" {
    source      = "bootstrap.sh"
    destination = "/tmp/bootstrap.sh"
  }


 connection {
    type     = "ssh"
    user     = "ec2-user"
    password = "DevOps321"
    host     = aws_instance.RabbitMq.private_ip
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/bootstrap.sh",
      "sudo sh /tmp/bootstrap.sh rabbitmq"
    ]
  }

}

resource "aws_route53_record" "MongoDb" {
  zone_id = var.zone_id
  name    = "mongodb.${var.zone_name}"
  type    = "A"
  ttl     = 1
  records = [aws_instance.MongoDb.private_ip]
}

resource "aws_route53_record" "Redis" {
  zone_id = var.zone_id
  name    = "redis.${var.zone_name}"
  type    = "A"
  ttl     = 1
  records = [aws_instance.Redis.private_ip]
}


resource "aws_route53_record" "MySql" {
  zone_id = var.zone_id
  name    = "mysql.${var.zone_name}"
  type    = "A"
  ttl     = 1
  records = [aws_instance.MySql.private_ip]
}

resource "aws_route53_record" "RabbitMq" {
  zone_id = var.zone_id
  name    = "rabbitmq.${var.zone_name}"
  type    = "A"
  ttl     = 1
  records = [aws_instance.RabbitMq.private_ip]
}