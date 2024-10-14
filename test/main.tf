module "multi_resource_module" {
  source = "../modules/cdn-test"
  bucket_name = "test"
  comment = "cdn-test.gracehpark.shop"
  aws_s3_bucket_ownership_controls = ""
  aws_s3_bucket_public_access_block = ""
  aws_s3_bucket_acl = ""

  lambda_name         = "my-dev-lambda"
  lambda_code_file    = "lambda_function.zip"

  domain_name                  = "cdn-test.gracehpark.shop"  # Route 53 도메인 이름
  zone_id                      = "Z07961164LVIQSCE98S7"  # Route 53 호스팅 존 ID
}
