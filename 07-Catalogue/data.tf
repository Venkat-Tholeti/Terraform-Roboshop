data "aws_ssm_parameter" "vpc_id" {
  name = "/${var.Project}/${var.Environment}/vpc_id"
}

data "aws_ssm_parameter" "private_subnet_id" {
  name  = "/${var.Project}/${var.Environment}/private_subnet_id"
}

data "aws_ssm_parameter" "Catalogue_sg_id" {
  name  = "/${var.Project}/${var.Environment}/Catalogue_sg_id" 
}


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
