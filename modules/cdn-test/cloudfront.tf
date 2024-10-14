resource "aws_cloudfront_origin_access_identity" "this" { ## OAI는 CloudFront에서 S3 버킷과의 연결 시 S3 버킷에 직접 접근하지 않고, CloudFront를 통해서만 접근하게 만드는 보안 설정
  comment = var.comment
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  depends_on = [aws_s3_bucket.this]  # S3 버킷이 먼저 생성되도록 설정
  origin { ## cloudfront s3 연결, OAI 로 cloudfront 를 통해서만 s3 버킷 접근 가능하게 설정
    domain_name = aws_s3_bucket.this.bucket_domain_name
    origin_id   = aws_s3_bucket.this.id

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.this.cloudfront_access_identity_path
    }
  }

  enabled             = true
  is_ipv6_enabled     = false
  comment             = var.comment
  aliases = var.aliases

  
  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = aws_s3_bucket.this.id
    viewer_protocol_policy = "redirect-to-https"

    # 캐시 정책 및 오리진 요청 정책 추가
    cache_policy_id            = var.cache_policy_id != "" ? var.cache_policy_id : null

    # 오리진 요청 정책: 사용자가 값을 제공하지 않으면 설정하지 않음
    origin_request_policy_id   = var.origin_request_policy_id != "" ? var.origin_request_policy_id : null

    # 응답 헤더 정책: 사용자가 값을 제공하지 않으면 설정하지 않음
    response_headers_policy_id = var.response_headers_policy_id != "" ? var.response_headers_policy_id : null
  
    # 람다
    # lambda_function_association {
    #   lambda_arn   = var.lambda_edge_viewer_response_arn != "" ? var.lambda_edge_viewer_response_arn : null
    #   event_type = "viewer-response"
    #   include_body = false
    # }

    # lambda_function_association {
    #   lambda_arn   = var.lambda_edge_origin_response_arn != "" ? var.lambda_edge_origin_response_arn : null
    #   event_type = "origin-response"
    #   include_body = false
    # }


  }

  viewer_certificate {
    acm_certificate_arn = aws_acm_certificate.cert.arn  # ACM에서 발급받은 인증서 참조
    ssl_support_method  = "sni-only"
    minimum_protocol_version = "TLSv1.2_2018"
    cloudfront_default_certificate = false
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"  # 모든 지역에서 접근을 허용 (필요시 'whitelist' 또는 'blacklist'로 변경)
    }
  }
}




## s3 버킷 도메인 이름을 cloudfront 원본으로 지정
## cloudfront 는 이 s3 버킷에서 콘텐츠 가져와서 사용자에게세 제공
## cloudfront 는 기본적으로 도메인 이름 생성됨
## route 53 에서 alias 레코드 생성해서 사용자 도메인을 cloudfront 도메인으로 연결 가능.
## 