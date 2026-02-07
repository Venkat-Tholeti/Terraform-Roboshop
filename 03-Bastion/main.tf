resource "aws_instance" "bastion" {
  ami           = local.ami_id
  instance_type = "t3.micro"

  tags = {
    Name = "HelloWorld"
  }
}