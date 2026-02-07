resource "aws_instance" "bastion" {
  ami           = local.ami_id
  instance_type = "t3.micro"
  vpc_security_group_ids  = "/${var.Project}/${var.Environment}/Bastion_sg_id"

  tags = {
    Name = "HelloWorld"
  }
}