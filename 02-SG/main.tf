module "Frontend" {
    source = "git::https://github.com/Venkat-Tholeti/Terraform-Module-SG.git?ref=main"
    project = var.project
    environment = var.environment
    sg_name = var.Frontend_sg_name
    sg_description = var.Frontend_sg_description

}