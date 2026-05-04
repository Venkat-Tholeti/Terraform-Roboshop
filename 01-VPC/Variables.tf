variable "project" {
  default = "Roboshop"
}

variable "environment"{
    default = "Dev"
}

variable "publicsubnet_cidr" {
    default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "privatesubnet_cidr" {
    default = ["10.0.11.0/24", "10.0.12.0/24"]
}

variable "databasesubnet_cidr" {
    default = ["10.0.21.0/24", "10.0.22.0/24"]
}