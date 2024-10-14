resource "aws_cloudfront_origin_access_identity" "this" { ## OAI는 CloudFront에서 S3 버킷과의 연결 시 S3 버킷에 직접 접근하지 않고, CloudFront를 통해서만 접근하게 만드는 보안 설정
  comment = var.comment
}
resource "aws_cloudfront_distribution" "s3_distribution" {
  origin { ## cloudfront s3 연결, OAI 로 cloudfront 를 통해서만 s3 버킷 접근 가능하게 설정
    domain_name = aws_s3_bucket.this.bucket_domain_name
    origin_id   = aws_s3_bucket.this.id

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.this.cloudfront_access_identity_path
    }
  }

  enabled = true

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "myOrigin"

    forwarded_values {
      query_string = false
    
      cookies {
          forward = "none"  # 쿠키를 전달하지 않음 (필요시 'all' 또는 'whitelist'로 변경)
      }
    }

    viewer_protocol_policy = "redirect-to-https"
  }

  viewer_certificate {
    cloudfront_default_certificate = true
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