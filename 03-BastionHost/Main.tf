resource "aws_instance" "bastion" {
   ami = local.ami_id
   instance_type = var.instance_size
   vpc_security_group_ids = local.bastion_sg_id
   subnet_id = 
   
   tags = merge(
      local.common_tags,
      {
         Name = "${var.project}-${var.environment}-BastionHost"
      }
   )
}
