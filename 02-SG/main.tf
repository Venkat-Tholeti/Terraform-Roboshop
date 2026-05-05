module "frontend" {
    #source = "../../Terraform-Module-SG"
    source ="git::https://github.com/Venkat-Tholeti/Terraform-Module-SG.git?ref=main"
    project = var.project
    environment = var.environment
    securitygroup_name = var.frontend_sg_name
    securitygroup_desc = var.frontend_sg_description
    vpc_id = local.vpc_id
}

module "bastion" {
    #source = "../../Terraform-Module-SG"
    source ="git::https://github.com/Venkat-Tholeti/Terraform-Module-SG.git?ref=main"
    project = var.project
    environment = var.environment
    securitygroup_name = var.bastion_sg_name
    securitygroup_desc = var.bastion_sg_description
    vpc_id = local.vpc_id
}

#Bastion accepting connection from my laptop
resource "aws_security_group_rule" "bastion_laptop" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]  # ⚠️ restrict in real use
  security_group_id = module.bastion.sg_id
}

module "Internal_ALB" {
    #source = "../../Terraform-Module-SG"
    source ="git::https://github.com/Venkat-Tholeti/Terraform-Module-SG.git?ref=main"
    project = var.project
    environment = var.environment
    securitygroup_name = var.Internal_ALB_sg_name
    securitygroup_desc = var.Internal_ALB_sg_description
    vpc_id = local.vpc_id
}


#BackendALB accepting connection from BastionHost
resource "aws_security_group_rule" "BackendALBAcceptingConnectionFromBastion" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.bastion.sg_id
  security_group_id = module.Internal_ALB.sg_id
}


module "vpn" {
    #source = "../../Terraform-Module-SG"
    source ="git::https://github.com/Venkat-Tholeti/Terraform-Module-SG.git?ref=main"
    project = var.project
    environment = var.environment
    securitygroup_name = var.vpn_sg_name
    securitygroup_desc = var.vpn_sg_description
    vpc_id = local.vpc_id
}

#VPN PORTS 22,443,1194,943
resource "aws_security_group_rule" "vpn_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.vpn.sg_id
}

resource "aws_security_group_rule" "vpn_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.vpn.sg_id
}

resource "aws_security_group_rule" "vpn_1194" {
  type              = "ingress"
  from_port         = 1194
  to_port           = 1194
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.vpn.sg_id
}

resource "aws_security_group_rule" "vpn_943" {
  type              = "ingress"
  from_port         = 943
  to_port           = 943
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.vpn.sg_id
}

#BackendALB accepting connection from VPN
resource "aws_security_group_rule" "Internal_ALB_VPN" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id = module.Internal_ALB.sg_id
}