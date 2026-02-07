module "vpc" {
   #source = "../Terraform-Module-VPC"
   # project = "Roboshop"
    #environment = "Dev"
    #public_subnet_cidr = ["10.0.1.0/24", "10.0.2.0/24"]
    
    source = "git::https://github.com/Venkat-Tholeti/Terraform-Module-VPC.git?ref=main" #We can create soure for git hub repos as well
    project = var.Project
    environment = var.Environment
    public_subnet_cidr = var.public_subnet_cidr
    private_subnet_cidr = var.private_subnet_cidr
    database_subnet_cidr = var.database_subnet_cidr

    is_peering_required = true

}
