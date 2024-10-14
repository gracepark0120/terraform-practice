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
    role_arn     = "arn:aws:iam::575841859611:role/terraformAssumedRole"
  }
}

# N. Virginia (us-east-1) 리전에서 사용되는 provider
provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
  profile = "personal"
}