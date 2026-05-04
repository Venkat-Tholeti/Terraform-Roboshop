module "frontend" {
    #source = "../../Terraform-Module-SG"
    source ="git::https://github.com/Venkat-Tholeti/Terraform-Module-SG.git?ref=main"
    project = var.project
    environment = var.environment
    securitygroup_name = var.sg_name
    securitygroup_desc = var.sg_description
    vpc_id = local.vpc_id
}