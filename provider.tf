terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "eu-west-1"
}

terraform {
  backend "s3" {
    bucket = "platform-app-state"
    key    = "deploy"
    region = "eu-west-1"
  }
}