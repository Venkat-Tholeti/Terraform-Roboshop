# DATA SOURCES ARE USED TO FETCH EXISTING INFRASTRUCTURE DETAILS WITHOUT CREATING THEM
# JUST FETCHING THE DETAILS, READ ONLY MODE #data = read
# ALREADY AWS LO UNA RESOURCES DETAILS FECTH CHESTHADI


data "aws_ami" "joindevops" {
   owners = [ "973714476881" ]
   most_recent = true
    
    filter {
      name = "name" #HERE RIGHT SIDE NAME IS AWS AMI ATTRIBUTE NAME, #LEFT SIDE IS TERRAFORM FILTER ARGUMENT
      values = [ "RHEL-9-DevOps-Practice" ]  # PROBLEM HERE IS WITH SAME NAME OTHE RPEOPLE ALSO CAN CREATE AMI'S , SO WE NEED TO USE MORE FILTERS
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

