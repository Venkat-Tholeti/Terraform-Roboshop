locals {
  common_tags = {
    Project = var.Project
    Environment = var.Environment
    TERRAFORM = true
  }

  ami_id = data.aws_ami.joindevops.id
  MongoDb_sg_id = data.aws_ssm_parameter.MongoDb_sg_id.value
  database_subnet_id = split("," , data.aws_ssm_parameter.database_subnet_id.value)[0]

}