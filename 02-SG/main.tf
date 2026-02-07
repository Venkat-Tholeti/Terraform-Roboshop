module "Frontend" {
    source = "git::https://github.com/Venkat-Tholeti/Terraform-Module-SG.git?ref=main"
    project = var.Project
    environment = var.Environment
    sg_name = var.Frontend_sg_name
    sg_description = var.Frontend_sg_description
    vpc_id = local.vpc_id

}