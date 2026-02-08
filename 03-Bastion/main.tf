resource "aws_instance" "bastion" {
  ami  = local.ami_id
  instance_type = "t3.micro"
  vpc_security_group_ids  = [local.Bastion_sg_id]
  subnet_id = local.public_subnet_id

  tags = merge(
    local.common_tags,
  {
    Name = "${var.Project}-${var.Environment}-Bastion"
  }
  )
}