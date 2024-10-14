provider "aws" {
  region = "us-east-1"  # 원하는 리전으로 변경하세요
}

module "multi_resource_module" {
  source = "../../modules/cdn-test"

  ami                 = "ami-0c55b159cbfafe1f0"
  instance_type       = "t2.micro"
  ec2_instance_name   = "my-dev-ec2"

  lambda_name         = "my-dev-lambda"
  lambda_code_file    = "lambda_function.zip"

  cloudfront_distribution_name = "my-cloudfront-distribution"
  domain_name                  = "example.com"  # Route 53 도메인 이름
  zone_id                      = "Z123456789ABC"  # Route 53 호스팅 존 ID
}

output "ec2_ip" {
  value = module.multi_resource_module.ec2_instance_public_ip
}

output "lambda_arn" {
  value = module.multi_resource_module.lambda_function_arn
}

output "cloudfront_domain" {
  value = module.multi_resource_module.cloudfront_domain_name
}
