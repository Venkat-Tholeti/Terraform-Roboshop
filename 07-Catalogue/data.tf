# DATA SOURCES ARE USED TO FETCH EXISTING INFRASTRUCTURE DETAILS WITHOUT CREATING THEM
# JUST FETCHING THE DETAILS, READ ONLY MODE #data = read
# ALREADY AWS LO UNA RESOURCES DETAILS FECTH CHESTHADI

data "aws_ami" "joindevops" {
   owners = [ "973714476881" ]
   most_recent = true
    
    filter {
      name = "name" #HERE RIGHT SIDE NAME IS AWS AMI ATTRIBUTE NAME, #LEFT SIDE IS TERRAFORM FILTER ARGUMENT
      values = [ "Redhat-9-DevOps-Practice" ]  # PROBLEM HERE IS WITH SAME NAME OTHE RPEOPLE ALSO CAN CREATE AMI'S , SO WE NEED TO USE MORE FILTERS
    }
    
    filter {
      name = "root-device-type"
      values = [ "ebs" ]
    }

    filter {
      name = "virtualization-type"
      values = ["hvm"]
    } 
}


data "aws_ssm_parameter" "database_subnet_id" {
  name = "/${var.Project}/${var.Environment}/database_subnet_id"
}

data "aws_ssm_parameter" "MongoDb_sg_id" {
  name = "/${var.Project}/${var.Environment}/MongoDb_sg_id"
}

data "aws_ssm_parameter" "RabbitMq_sg_id" {
  name = "/${var.Project}/${var.Environment}/RabbitMq_sg_id"
}

data "aws_ssm_parameter" "Redis_sg_id" {
  name = "/${var.Project}/${var.Environment}/Redis_sg_id"
}

data "aws_ssm_parameter" "MySql_sg_id" {
  name = "/${var.Project}/${var.Environment}/MySql_sg_id"
}
