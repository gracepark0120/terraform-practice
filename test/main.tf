module "multi_resource_module" {
  source = "../modules/cdn-test"
  bucket_name = "grace-cdn-test-test"
  comment = "grace-cdn-test-test.gracehpark.shop"
  aws_s3_bucket_ownership_controls = ""
  aws_s3_bucket_public_access_block = ""
  aws_s3_bucket_acl = ""

#   lambda_name         = "my-dev-lambda"
#   lambda_code_file    = "lambda_function.zip"
  aliases                      = ["grace-cdn-test-test.gracehpark.shop"] 
  domain_name                  = "grace-cdn-test-test.gracehpark.shop"  # Route 53 도메인 이름
  zone_id                      = "Z04134461GZON1SRR54AP"  # Route 53 호스팅 존 ID
}
