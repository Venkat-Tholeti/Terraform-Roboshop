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


module "VPN" {
    source = "git::https://github.com/Venkat-Tholeti/Terraform-Module-SG.git?ref=main"
    project = var.Project
    environment = var.Environment
    sg_name = var.VPN_sg_name
    sg_description = var.VPN_sg_description
    vpc_id = local.vpc_id
}

#VPN PORTS 22,443,1194,943
resource "aws_security_group_rule" "VPN_SSH" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.VPN.sg_id
}

resource "aws_security_group_rule" "VPN_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.VPN.sg_id
}

resource "aws_security_group_rule" "VPN_1194" {
  type              = "ingress"
  from_port         = 1194
  to_port           = 1194
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.VPN.sg_id
}

resource "aws_security_group_rule" "VPN_943" {
  type              = "ingress"
  from_port         = 943
  to_port           = 943
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.VPN.sg_id
}


#BACKEND ALB ACCEPTING CONNECTIONS FROM VPN HOST ON PORT 80
resource "aws_security_group_rule" "Backend_ALB_Connection_From_VPN" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.VPN.sg_id # HERE WE ARE USING SECURITY GROUP INSTEAD OF CIDR OR IP, BECAUSE IF BASTION INSTANCE GET RECREATED, IP MAY CHANGE SO WE ARE GIVING SG WHERE BASTION RESIDE.
  security_group_id = module.Backend_ALB.sg_id
}

module "MongoDb" {
    source = "git::https://github.com/Venkat-Tholeti/Terraform-Module-SG.git?ref=main"
    project = var.Project
    environment = var.Environment
    sg_name = var.MongoDb_sg_name
    sg_description = var.MongoDb_sg_description
    vpc_id = local.vpc_id
}

#MONGODB ACCEPTING CONNECTIONS FROM VPN HOST ON PORT 22 & 27017
resource "aws_security_group_rule" "MONGODB_SSH_From_VPN" {
  count = length(var.MongoDb_Ports_VPN)
  type              = "ingress"
  from_port         = var.MongoDb_Ports_VPN[count.index]
  to_port           = var.MongoDb_Ports_VPN[count.index]
  protocol          = "tcp"
  source_security_group_id = module.VPN.sg_id # HERE WE ARE USING SECURITY GROUP INSTEAD OF CIDR OR IP, BECAUSE IF BASTION INSTANCE GET RECREATED, IP MAY CHANGE SO WE ARE GIVING SG WHERE BASTION RESIDE.
  security_group_id = module.MongoDb.sg_id 
}

# resource "aws_security_group_rule" "MONGODB_From_VPN" {
#   type              = "ingress"
#   from_port         = 27017
#   to_port           = 27017
#   protocol          = "tcp"
#   source_security_group_id = module.VPN.sg_id # HERE WE ARE USING SECURITY GROUP INSTEAD OF CIDR OR IP, BECAUSE IF BASTION INSTANCE GET RECREATED, IP MAY CHANGE SO WE ARE GIVING SG WHERE BASTION RESIDE.
#   security_group_id = module.MongoDb.sg_id
# }

module "Redis" {
    source = "git::https://github.com/Venkat-Tholeti/Terraform-Module-SG.git?ref=main"
    project = var.Project
    environment = var.Environment
    sg_name = var.Redis_sg_name
    sg_description = var.Redis_sg_description
    vpc_id = local.vpc_id
}

#MONGODB ACCEPTING CONNECTIONS FROM VPN HOST ON PORTS
resource "aws_security_group_rule" "Redis_SSH_From_VPN" {
  count = length(var.Redis_Ports_VPN)
  type              = "ingress"
  from_port         = var.Redis_Ports_VPN[count.index]
  to_port           = var.Redis_Ports_VPN[count.index]
  protocol          = "tcp"
  source_security_group_id = module.VPN.sg_id # HERE WE ARE USING SECURITY GROUP INSTEAD OF CIDR OR IP, BECAUSE IF BASTION INSTANCE GET RECREATED, IP MAY CHANGE SO WE ARE GIVING SG WHERE BASTION RESIDE.
  security_group_id = module.Redis.sg_id 
}

module "MySql" {
    source = "git::https://github.com/Venkat-Tholeti/Terraform-Module-SG.git?ref=main"
    project = var.Project
    environment = var.Environment
    sg_name = var.MySql_sg_name
    sg_description = var.MySql_sg_description
    vpc_id = local.vpc_id
}

#MONGODB ACCEPTING CONNECTIONS FROM VPN HOST ON PORTS
resource "aws_security_group_rule" "MySql_SSH_From_VPN" {
  count = length(var.MySql_Ports_VPN)
  type              = "ingress"
  from_port         = var.MySql_Ports_VPN[count.index]
  to_port           = var.MySql_Ports_VPN[count.index]
  protocol          = "tcp"
  source_security_group_id = module.VPN.sg_id # HERE WE ARE USING SECURITY GROUP INSTEAD OF CIDR OR IP, BECAUSE IF BASTION INSTANCE GET RECREATED, IP MAY CHANGE SO WE ARE GIVING SG WHERE BASTION RESIDE.
  security_group_id = module.MySql.sg_id 
}

module "RabbitMq" {
    source = "git::https://github.com/Venkat-Tholeti/Terraform-Module-SG.git?ref=main"
    project = var.Project
    environment = var.Environment
    sg_name = var.RabbitMq_sg_name
    sg_description = var.RabbitMq_sg_description
    vpc_id = local.vpc_id
}

#MONGODB ACCEPTING CONNECTIONS FROM VPN HOST ON PORTS
resource "aws_security_group_rule" "RabbitMq_SSH_From_VPN" {
  count = length(var.RabbitMq_Ports_VPN)
  type              = "ingress"
  from_port         = var.RabbitMq_Ports_VPN[count.index]
  to_port           = var.RabbitMq_Ports_VPN[count.index]
  protocol          = "tcp"
  source_security_group_id = module.VPN.sg_id # HERE WE ARE USING SECURITY GROUP INSTEAD OF CIDR OR IP, BECAUSE IF BASTION INSTANCE GET RECREATED, IP MAY CHANGE SO WE ARE GIVING SG WHERE BASTION RESIDE.
  security_group_id = module.RabbitMq.sg_id 
}