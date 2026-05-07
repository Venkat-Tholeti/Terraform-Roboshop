resource "aws_instance" "mongodb" {
   ami = local.ami_id
   instance_type = var.instance_size
   vpc_security_group_ids = [local.mongodb_sg_id]
   subnet_id = local.database_subnet_ids
   
   tags = merge(
      local.common_tags,
      {
         Name = "${var.project}-${var.environment}-MongoDB"
      }
   )
}

#null resource
resource "terraform_data" "mongodb" {
  triggers_replace = [
    aws_instance.mongodb.id #when instance id is changed it will trigger
  ]
  
  #Connect to instance  & COPY FILE FROM LOCAL TO instance
  provisioner "file" {
    source      = "bootstrap.sh"
    destination = "/tmp/bootstrap.sh"
  }

  connection {
    type     = "ssh"
    user     = "ec2-user"
    password = "DevOps321"
    host     = aws_instance.mongodb.private_ip
  }
  # Remote EXEC to connect to server and execute the script $1 is mongodb $2 is environment here
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/bootstrap.sh",
      "sudo sh /tmp/bootstrap.sh mongodb ${var.environment}"
    ]
  }
}


# resource "aws_instance" "redis" {
#    ami = local.ami_id
#    instance_type = var.instance_size
#    vpc_security_group_ids = [local.redis_sg_id]
#    subnet_id = local.database_subnet_ids
   
#    tags = merge(
#       local.common_tags,
#       {
#          Name = "${var.project}-${var.environment}-Redis"
#       }
#    )
# }

# #null resource
# resource "terraform_data" "redis" {
#   triggers_replace = [
#     aws_instance.redis.id #when instance id is changed it will trigger
#   ]
  
#   #Connect to instance  & COPY FILE FROM LOCAL TO instance
#   provisioner "file" {
#     source      = "bootstrap.sh"
#     destination = "/tmp/bootstrap.sh"
#   }

#   connection {
#     type     = "ssh"
#     user     = "ec2-user"
#     password = "DevOps321"
#     host     = aws_instance.redis.private_ip
#   }
#   # Remote EXEC to connect to server and execute the script $1 is redis $2 is environment here
#   provisioner "remote-exec" {
#     inline = [
#       "chmod +x /tmp/bootstrap.sh",
#       "sudo sh /tmp/bootstrap.sh redis ${var.environment}"
#     ]
#   }
# }




# resource "aws_instance" "mysql" {
#    ami = local.ami_id
#    instance_type = var.instance_size
#    vpc_security_group_ids = [local.mysql_sg_id]
#    subnet_id = local.database_subnet_ids
#    iam_instance_profile = "Ec2RoleToFetchSSMParameters" #This role is used To Fetch Mysql root password from SSM parameter store
   
#    tags = merge(
#       local.common_tags,
#       {
#          Name = "${var.project}-${var.environment}-MySql"
#       }
#    )
# }

# #null resource
# resource "terraform_data" "mysql" {
#   triggers_replace = [
#     aws_instance.mysql.id #when instance id is changed it will trigger
#   ]
  
#   #Connect to instance  & COPY FILE FROM LOCAL TO instance
#   provisioner "file" {
#     source      = "bootstrap.sh"
#     destination = "/tmp/bootstrap.sh"
#   }

#   connection {
#     type     = "ssh"
#     user     = "ec2-user"
#     password = "DevOps321"
#     host     = aws_instance.mysql.private_ip
#   }
#   # Remote EXEC to connect to server and execute the script $1 is mysql $2 is environment here
#   provisioner "remote-exec" {
#     inline = [
#       "chmod +x /tmp/bootstrap.sh",
#       "sudo sh /tmp/bootstrap.sh mysql ${var.environment}"
#     ]
#   }
# }





# resource "aws_instance" "rabbitmq" {
#    ami = local.ami_id
#    instance_type = var.instance_size
#    vpc_security_group_ids = [local.rabbitmq_sg_id]
#    subnet_id = local.database_subnet_ids
   
#    tags = merge(
#       local.common_tags,
#       {
#          Name = "${var.project}-${var.environment}-RabbitMq"
#       }
#    )
# }

# #null resource
# resource "terraform_data" "rabbitmq" {
#   triggers_replace = [
#     aws_instance.rabbitmq.id #when instance id is changed it will trigger
#   ]
  
#   #Connect to instance  & COPY FILE FROM LOCAL TO instance
#   provisioner "file" {
#     source      = "bootstrap.sh"
#     destination = "/tmp/bootstrap.sh"
#   }

#   connection {
#     type     = "ssh"
#     user     = "ec2-user"
#     password = "DevOps321"
#     host     = aws_instance.rabbitmq.private_ip
#   }
#   # Remote EXEC to connect to server and execute the script $1 is rabbitmq $2 is environment here
#   provisioner "remote-exec" {
#     inline = [
#       "chmod +x /tmp/bootstrap.sh",
#       "sudo sh /tmp/bootstrap.sh rabbitmq ${var.environment}"
#     ]
#   }
# }

resource "aws_route53_record" "mongodb" {
  zone_id = var.hosted_zone_id # ID of your Route 53 hosted zone
  name    = "mongodb.${var.zone_name}" # mongodb.devopsaws.store
  type    = "A"
  ttl     = 1
  records = [aws_instance.mongodb.private_ip]
}

# resource "aws_route53_record" "redis" {
#   zone_id = var.hosted_zone_id # ID of your Route 53 hosted zone
#   name    = "redis.${var.zone_name}" # redis.devopsaws.store
#   type    = "A"
#   ttl     = 1
#   records = [aws_instance.redis.private_ip]
# }

# resource "aws_route53_record" "mysql" {
#   zone_id = var.hosted_zone_id # ID of your Route 53 hosted zone
#   name    = "mysql.${var.zone_name}" # mysql.devopsaws.store
#   type    = "A"
#   ttl     = 1
#   records = [aws_instance.mysql.private_ip]
# }

# resource "aws_route53_record" "rabbitmq" {
#   zone_id = var.hosted_zone_id # ID of your Route 53 hosted zone
#   name    = "rabbitmq.${var.zone_name}" # rabbitmq.devopsaws.store
#   type    = "A"
#   ttl     = 1
#   records = [aws_instance.rabbitmq.private_ip]
# }