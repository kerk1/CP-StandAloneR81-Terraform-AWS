terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Specify the provider and access details
provider "aws" {
  region = var.aws_region
}