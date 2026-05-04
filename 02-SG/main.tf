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

