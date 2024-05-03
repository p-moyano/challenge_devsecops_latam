#Defino los providers para el proyecto
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>4.36.0"
    }
  }
  required_version = "~>1.8.2"
  backend "s3" {
    bucket         = "challenge-devsecops-tfstate"
    key            = "s3/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "challenge-devsecops-tflock"
    encrypt        = true
  }
}

provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = var.tags
  }
}