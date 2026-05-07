resource "aws_instance" "vpn" {
   ami = local.ami_id
   instance_type = var.instance_size
   vpc_security_group_ids = [local.vpn_sg_id]
   subnet_id = local.public_subnet_ids
   key_name = "KEY2026" #make sure this key exist in AWS
   user_data = file("openvpn.sh")
   
   tags = merge(
      local.common_tags,
      {
         Name = "${var.project}-${var.environment}-VPN"
      }
   )
}

resource "aws_route53_record" "vpn" {
  zone_id = var.hosted_zone_id # ID of your Route 53 hosted zone
  name    = "vpn.${var.zone_name}" # rabbitmq.devopsaws.store
  type    = "A"
  ttl     = 1
  records = [aws_instance.vpn.public_ip]
  allow_overwrite = true
}