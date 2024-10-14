variable "ami" {
  description = "The AMI ID for the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "The EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "ec2_instance_name" {
  description = "The name tag for the EC2 instance"
  type        = string
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