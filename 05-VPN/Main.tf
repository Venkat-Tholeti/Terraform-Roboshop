resource "aws_instance" "vpn" {
   ami = local.ami_id
   instance_type = var.instance_size
   vpc_security_group_ids = [local.vpn_sg_id]
   subnet_id = local.public_subnet_ids
   key_name = "KEY2026" #make sure this key exist in AWS
   
   tags = merge(
      local.common_tags,
      {
         Name = "${var.project}-${var.environment}-VPN"
      }
   )
}