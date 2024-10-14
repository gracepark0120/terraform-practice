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
  region = "ap-northeast-1"

  max_retries = 5

  assume_role {
    role_arn     = "arn:aws:iam:::role/assume-role-mgmt-atlantis"
  }
}
