terraform {
  required_version = ">= 1.0.1"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.47"
    }
  }
}

provider "aws" {
  profile = "personal"
  region = "ap-south-1"

  max_retries = 5

  assume_role {
    role_arn     = "arn:aws:iam::{accountid}:role/terraformAssumedRole"
  }
}
