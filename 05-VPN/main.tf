resource "aws_key_pair" "VPN" {
  key_name   = "vpn"
  public_key = file("E:\\Bobby\\NANI\\DEVOPS PRACTICE\\Keys\\vpn.pub") 
}

resource "aws_instance" "VPN" {
  ami  = local.ami_id
  instance_type = "t3.micro"
  vpc_security_group_ids  = [local.VPN_sg_id]
  subnet_id = local.public_subnet_id
  key_name = "aws_key_pair.VPN.key_name" #KEY PAIR NAME, MAKE SURE THIS EXISTS IN AWS
  #key_name = vpn #If key is already present in aws use this or else use above to import the key to aws
  user_data = file("openvpn.sh")


  tags = merge(
    local.common_tags,
  {
    Name = "${var.Project}-${var.Environment}-VPN"
  }
  )
}