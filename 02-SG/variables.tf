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