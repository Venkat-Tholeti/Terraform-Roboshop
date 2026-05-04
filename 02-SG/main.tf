module "frontend" {
    source = "../../Terraform-Module-SG"
    project = var.project
    environment = var.environment
    securitygroup_name = var.sg_name
    securitygroup_desc = var.sg_description
}