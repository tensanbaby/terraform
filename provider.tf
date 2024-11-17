terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"  # Adjust the version as needed
    }
  }

  required_version = ">= 1.3.0"  # Adjust based on your Terraform CLI version
}

provider "aws" {
  region = "us-east-1"  # Specify your AWS region
}
