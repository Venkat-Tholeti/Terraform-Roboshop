module "Frontend" {
    source = "git::https://github.com/Venkat-Tholeti/Terraform-Module-SG.git?ref=main"
    project = var.Project
    environment = var.Environment
    sg_name = var.Frontend_sg_name
    sg_description = var.Frontend_sg_description
    vpc_id = local.vpc_id
}

module "Bastion" {
    source = "git::https://github.com/Venkat-Tholeti/Terraform-Module-SG.git?ref=main"
    project = var.Project
    environment = var.Environment
    sg_name = var.Bastion_sg_name
    sg_description = var.Bastion_sg_description
    vpc_id = local.vpc_id
}

#BASTION ACCEPTING CONNECTIONS FROM MY LAPTOP.IF IN OFFICE WE HAVE TO GIVE OUR NETWORK CIDR
resource "aws_security_group_rule" "Bastion_Laptop" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.Bastion.sg_id
}