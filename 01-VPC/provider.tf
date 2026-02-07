terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.26.0"
    }
  }

 backend "s3" {
  bucket         = "terraform-practice-daws84s"
  key            = "vpc_ROBOSHOP"
  region         = "us-east-1"
  encrypt        = true
  #dynamodb_table = "terraform-remote-state"
  use_lockfile = true # BEFORE WE USED TO USE DYNAMO DB FOR LOCKING NOW IN S3 WE HAD THIS OPTION TO SECURE
 }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

#ANY CHANGES IN PROVIDER FILE, WE HAVE TO RUN TERRAFORM INIT -RECONFIGURE