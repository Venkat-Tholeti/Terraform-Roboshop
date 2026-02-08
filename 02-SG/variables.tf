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

variable "VPN_sg_name" {
    default = "VPN"
}

variable "VPN_sg_description" {
    default = "Security Group For VPN" 

}
variable "MongoDb_sg_name" {
    default = "MongoDb"
}

variable "MongoDb_sg_description" {
    default = "Security Group For MongoDb" 
}

variable "MongoDb_Ports_VPN" {
    default = [22, 27017]
}


variable "Redis_sg_name" {
    default = "MySql"
}

variable "Redis_sg_description" {
    default = "Security Group For Redis" 
}

variable "Redis_Ports_VPN" {
    default = [22, 6379]
}



variable "MySql_sg_name" {
    default = "MySql"
}

variable "MySql_sg_description" {
    default = "Security Group For MySql" 
}

variable "MySql_Ports_VPN" {
    default = [22, 3306]
}



variable "RabbitMq_sg_name" {
    default = "RabbitMq"
}

variable "RabbitMq_sg_description" {
    default = "Security Group For RabbitMq" 
}

variable "RabbitMq_Ports_VPN" {
    default = [22, 5672]
}