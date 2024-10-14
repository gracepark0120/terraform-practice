resource "aws_cloudfront_distribution" "my_distribution" {
  origin {
    domain_name = aws_instance.example.public_dns
    origin_id   = "myOrigin"
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
