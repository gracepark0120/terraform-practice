variable "bucket_name" {}
variable "comment" {}
variable "aws_s3_bucket_ownership_controls" {}
variable "aws_s3_bucket_public_access_block" {}
variable "aws_s3_bucket_acl" {}
variable "aliases" {
  type = list(string)
}
variable "enable_aws_s3_public" {
  type        = bool
  default     = false
}
# variable "lambda_name" {
#   description = "Name of the Lambda function"
#   type        = string
# }

# variable "lambda_handler" {
#   description = "Handler for the Lambda function"
#   type        = string
#   default     = "lambda_function.lambda_handler"
# }

# variable "lambda_code_file" {
#   description = "Path to the Lambda function zip file"
#   type        = string
# }

# # lambda edge 설정
# variable "lambda_edge_viewer_response_arn" {
#   type        = string
#   default     = ""
# }

# variable "lambda_edge_origin_response_arn" {
#   type        = string
#   default     = ""
# }

variable "cache_policy_id" {
  type    = string
  default = ""  # 기본적으로 비어 있도록 설정
}

variable "origin_request_policy_id" {
  type    = string
  default = ""  # 기본적으로 비어 있도록 설정
}

variable "response_headers_policy_id" {
  type    = string
  default = ""  # 기본적으로 비어 있도록 설정
}
variable "zone_id" {
  description = "Handler for the Lambda function"
  type        = string
}

variable "domain_name" {
  type        = string
}

variable "default_ttl" {
  type    = number
  default = 86400  # 1일 (초 단위)
}

variable "max_ttl" {
  type    = number
  default = 31536000  # 1년 (초 단위)
}

variable "min_ttl" {
  type    = number
  default = 0  # 기본적으로 최소 TTL을 0으로 설정
}
