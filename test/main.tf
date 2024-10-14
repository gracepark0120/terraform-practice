module "multi_resource_module" {
  source = "../modules/cdn-test"
  bucket_name = "grace-cdn-test-test"
  comment = "grace-cdn-test-test.gracehpark.shop"
  
  cache_policy_id            = aws_cloudfront_cache_policy.cdn-cahce-test.id  #CachingOptimized
  origin_request_policy_id   = "" 
  response_headers_policy_id = ""

#   lambda_name         = "my-dev-lambda"
#   lambda_code_file    = "lambda_function.zip"

  aliases                      = ["grace-cdn-test-test.gracehpark.shop"] 
  domain_name                  = "grace-cdn-test-test.gracehpark.shop"  # Route 53 도메인 이름
  zone_id                      = "Z04134461GZON1SRR54AP"  # Route 53 호스팅 존 ID

  enable_aws_s3_public = false
  aws_s3_bucket_ownership_controls = ""
  aws_s3_bucket_public_access_block = ""
  aws_s3_bucket_acl = ""
  # 버전 명시 필요
  lambda_edge_viewer_response_arn = "arn:aws:lambda:us-east-1:575841859611:function:setting-json-custom-headers:1"
  lambda_edge_origin_response_arn = "arn:aws:lambda:us-east-1:575841859611:function:setting-json-custom-headers:1"

}
### policy6
# cache policy
resource "aws_cloudfront_cache_policy" "cdn-cahce-test" {
  name = "cdn-cahce-test"

  default_ttl = 3  # 기본 TTL
  max_ttl     = 3      # 최대 TTL
  min_ttl     = 3     # 최소 TTL

  parameters_in_cache_key_and_forwarded_to_origin {
    enable_accept_encoding_brotli = true
    enable_accept_encoding_gzip   = true

    headers_config {
      header_behavior = "none"
    }

    cookies_config {
      cookie_behavior = "none"
    }

    query_strings_config {
      query_string_behavior = "none"
    }
  }
}

# # origin policy
# resource "aws_cloudfront_origin_request_policy" "custom_request_policy" {
#   name = "${var.bucket_name}-request-policy"
#   comment = "Custom Origin Request Policy for CloudFront"

#   headers_config {
#     header_behavior = "whitelist"
#     headers = ["Host", "Origin"]  # 오리진으로 전달할 헤더들
#   }

#   cookies_config {
#     cookie_behavior = "none"  # 쿠키를 오리진으로 전달하지 않음
#   }

#   query_strings_config {
#     query_string_behavior = "all"  # 모든 쿼리 문자열을 오리진으로 전달
#   }
# }
