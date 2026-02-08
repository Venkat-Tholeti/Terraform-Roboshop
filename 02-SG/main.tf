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

module "Backend_ALB" {
    source = "git::https://github.com/Venkat-Tholeti/Terraform-Module-SG.git?ref=main"
    project = var.Project
    environment = var.Environment
    sg_name = var.Backend_ALB_sg_name
    sg_description = var.Backend_ALB_sg_description
    vpc_id = local.vpc_id
}

#BACKEND ALB ACCEPTING CONNECTIONS FROM BASTION HOST ON PORT 80
resource "aws_security_group_rule" "Backend_ALB_Connection_From_Bastion" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.Bastion.sg_id # HERE WE ARE USING SECURITY GROUP INSTEAD OF CIDR OR IP, BECAUSE IF BASTION INSTANCE GET RECREATED, IP MAY CHANGE SO WE ARE GIVING SG WHERE BASTION RESIDE.
  security_group_id = module.Backend_ALB.sg_id
}