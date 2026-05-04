module "vpc" {
    #source = "../Terraform-Module-VPC"
    source = "git::https://github.com/Venkat-Tholeti/Terraform-Module-VPC.git?ref=main"
    project = var.project
    environment = var.environment
    public_subnet_cidr = var.publicsubnet_cidr
    private_subnet_cidr = var.privatesubnet_cidr
    database_subnet_cidr = var.databasesubnet_cidr
  
}