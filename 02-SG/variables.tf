variable "Project" {
    default = "Roboshop"
}

variable "Environment" {
    default = "Dev" 
}

variable "Frontend_sg_name" {
    default = "Frontend"
}

variable "Frontend_sg_description" {
    default = "Security Group For Frontend" 
}

variable "Bastion_sg_name" {
    default = "Bastion"
}

variable "Bastion_sg_description" {
    default = "Security Group For Bastion" 
}

variable "Backend_ALB_sg_name" {
    default = "Backend-ALB"
}

variable "Backend_ALB_sg_description" {
    default = "Security Group For Backend ALB" 
}