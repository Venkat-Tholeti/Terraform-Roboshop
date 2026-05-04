module "vpc" {
    #source = "../Terraform-Module-VPC"
    source = "git::https://github.com/Venkat-Tholeti/Terraform-Module-VPC.git?ref=main"
    project = var.project
    environment = var.environment
    public_subnet_cidr = var.publicsubnet_cidr
    private_subnet_cidr = var.privatesubnet_cidr
    database_subnet_cidr = var.databasesubnet_cidr
  
}

# output "vpc_id" {
#   value = module.vpc.vpc_id #vpc_id here is the output name of Module VPC, check in module-vpc for more
# } # instead of this wrote parameters.terraform
  
