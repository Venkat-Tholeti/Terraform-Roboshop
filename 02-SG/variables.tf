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

variable "redis_sg_name" {
    default = "redis"  
}

variable "redis_sg_description" {
    default = "sg for redis" 
}

variable "redis_ports_vpn" {
    default = [22, 6379]
}

variable "mysql_sg_name" {
    default = "mysql"  
}

variable "mysql_sg_description" {
    default = "sg for mysql" 
}

variable "mysql_ports_vpn" {
    default = [22, 3306]
}

variable "rabbitmq_sg_name" {
    default = "rabbitmq"  
}

variable "rabbitmq_sg_description" {
    default = "sg for rabbitmq" 
}

variable "rabbitmq_ports_vpn" {
    default = [22, 5672]
}