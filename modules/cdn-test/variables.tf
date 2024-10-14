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
variable "lambda_name" {
  description = "Name of the Lambda function"
  type        = string
}

variable "lambda_handler" {
  description = "Handler for the Lambda function"
  type        = string
  default     = "lambda_function.lambda_handler"
}

variable "lambda_code_file" {
  description = "Path to the Lambda function zip file"
  type        = string
}

# lambda edge 설정
variable "lambda_edge_viewer_response_arn" {
  type        = string
  default     = ""
}

variable "lambda_edge_origin_response_arn" {
  type        = string
  default     = ""
}

variable "cache_policy_id" {}
variable "origin_request_policy_id" {}
variable "response_headers_policy_id" {}
variable "zone_id" {
  description = "Handler for the Lambda function"
  type        = string
}

variable "domain_name" {
  type        = string
}