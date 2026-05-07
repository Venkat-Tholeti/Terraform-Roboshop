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

module "mongodb" {
    #source = "../../Terraform-Module-SG"
    source ="git::https://github.com/Venkat-Tholeti/Terraform-Module-SG.git?ref=main"
    project = var.project
    environment = var.environment
    securitygroup_name = var.mongodb_sg_name
    securitygroup_desc = var.mongodb_sg_description
    vpc_id = local.vpc_id
}

#MOngodb accepting connections from VPN to verify only
resource "aws_security_group_rule" "mongodb_vpn" {
  count = length(var.mongodb_ports_vpn)
  type              = "ingress"
  from_port         = var.mongodb_ports_vpn[count.index]
  to_port           = var.mongodb_ports_vpn[count.index]
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id = module.mongodb.sg_id
}

module "redis" {
    #source = "../../Terraform-Module-SG"
    source ="git::https://github.com/Venkat-Tholeti/Terraform-Module-SG.git?ref=main"
    project = var.project
    environment = var.environment
    securitygroup_name = var.redis_sg_name
    securitygroup_desc = var.redis_sg_description
    vpc_id = local.vpc_id
}

#Redis accepting connections from VPN to verify only
resource "aws_security_group_rule" "redis_vpn" {
  count = length(var.redis_ports_vpn)
  type              = "ingress"
  from_port         = var.redis_ports_vpn[count.index]
  to_port           = var.redis_ports_vpn[count.index]
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id = module.redis.sg_id
}

module "mysql" {
    #source = "../../Terraform-Module-SG"
    source ="git::https://github.com/Venkat-Tholeti/Terraform-Module-SG.git?ref=main"
    project = var.project
    environment = var.environment
    securitygroup_name = var.mysql_sg_name
    securitygroup_desc = var.mysql_sg_description
    vpc_id = local.vpc_id
}

#MySql accepting connections from VPN to verify only
resource "aws_security_group_rule" "mysql_vpn" {
  count = length(var.mysql_ports_vpn)
  type              = "ingress"
  from_port         = var.mysql_ports_vpn[count.index]
  to_port           = var.mysql_ports_vpn[count.index]
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id = module.mysql.sg_id
}


module "rabbitmq" {
    #source = "../../Terraform-Module-SG"
    source ="git::https://github.com/Venkat-Tholeti/Terraform-Module-SG.git?ref=main"
    project = var.project
    environment = var.environment
    securitygroup_name = var.rabbitmq_sg_name
    securitygroup_desc = var.rabbitmq_sg_description
    vpc_id = local.vpc_id
}

#RabbitMq accepting connections from VPN to verify only
resource "aws_security_group_rule" "rabbitmq_vpn" {
  count = length(var.rabbitmq_ports_vpn)
  type              = "ingress"
  from_port         = var.rabbitmq_ports_vpn[count.index]
  to_port           = var.rabbitmq_ports_vpn[count.index]
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id = module.rabbitmq.sg_id
}