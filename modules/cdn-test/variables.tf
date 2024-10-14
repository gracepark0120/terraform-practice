variable "bucket_name" {}
variable "comment" {}
variable "aws_s3_bucket_ownership_controls" {}
variable "aws_s3_bucket_public_access_block" {}
variable "aws_s3_bucket_acl" {}
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

variable "zone_id" {
  description = "Handler for the Lambda function"
  type        = string
}

variable "domain_name" {
  type        = string
}