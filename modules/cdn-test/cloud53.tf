# 기본 리전 (ap-south-1)
provider "aws" {
  region = "ap-south-1"
  profile = "personal" 
}

# N. Virginia (us-east-1) 리전에서 사용되는 provider
provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
  profile = "personal" 
}

resource "aws_route53_record" "www" {
  zone_id = var.zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.s3_distribution.domain_name ## cloudfront 배포의 도메인 이름 참조. cloudfront 배포 완료되면 해당 도메인 이름 생성되어 이 도메인 이름으로 트래픽 라우팅됨
    zone_id                = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
    evaluate_target_health = true
  }
}

resource "aws_acm_certificate" "cert" {
  provider          = aws.us_east_1
  domain_name       = var.domain_name
  validation_method = "DNS"
}

# A 레코드를 생성 - alias 
# zone_id : 연결할 route53 호스팅 영역. cloudfront 배포의 호스팅 영역 id 참조
# domain_name : 사용자가 연결하려는 도메인 이름

resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      type   = dvo.resource_record_type
      record = dvo.resource_record_value
    }
  }

  zone_id = var.zone_id
  name    = each.value.name
  type    = each.value.type
  records = [each.value.record]
  ttl     = 60
}

## ssl 인증서는 cloudfront 에서 사용하려면 us-east-1 에 존재해야함
