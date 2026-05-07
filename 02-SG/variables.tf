variable "project" {
  default = "Roboshop"
}

variable "environment"{
    default = "Dev"
}
variable "frontend_sg_name" {
    default = "Frontend"  
}

variable "frontend_sg_description" {
    default = "Sg for Frontend" 
}

variable "bastion_sg_name" {
    default = "Bastion"  
}

variable "bastion_sg_description" {
    default = "Sg for Bastion" 
}

variable "Internal_ALB_sg_name" {
    default = "Internal_ALB"  
}

variable "Internal_ALB_sg_description" {
    default = "sg for internal alb" 
}

variable "vpn_sg_name" {
    default = "vpn"  
}

variable "vpn_sg_description" {
    default = "sg for vpn" 
}

variable "mongodb_sg_name" {
    default = "mongodb"  
}

variable "mongodb_sg_description" {
    default = "sg for mongodb" 
}

variable "mongodb_ports_vpn" {
    default = [22, 27017]
}