# Hosted Zone
resource "aws_route53_zone" "grace_zone" {
  name = "gracehpark.shop"  # 가비아에서 등록한 도메인

  tags = {
    Name = "MyDomainZone"
  }
}

# 도메인을 nlb 로 연결
resource "aws_route53_record" "my_domain" {
  zone_id = aws_route53_zone.grace_zone.zone_id  # Route 53 Hosted Zone ID
  name    = "gracehpark.shop"                    # 가비아에서 사용 중인 도메인
  type    = "A" # alias 설정

  alias {
    name                   = aws_lb.nlb.dns_name   # ✅ NLB의 DNS 주소 사용
    zone_id                = aws_lb.nlb.zone_id    # ✅ NLB의 Zone ID
    evaluate_target_health = true                  # ✅ 로드밸런서 상태에 따라 도메인 활성화 여부 판단
  }
}

# CNAME 으로 서브도메인 등록
resource "aws_route53_record" "www_record" {
  zone_id = aws_route53_zone.grace_zone.zone_id
  name    = "www.gracehpark.shop"
  type    = "CNAME"
  ttl     = 300
  records = [aws_lb.nlb.dns_name]
}

# ACM
resource "aws_acm_certificate" "grace_cert" {
  domain_name       = "gracehpark.shop"  # 주 도메인
  validation_method = "DNS"            # DNS 검증 사용 (Route 53)

  subject_alternative_names = [
    "*.gracehpark.shop"  # 와일드카드 인증서 (서브도메인도 HTTPS 지원)
  ]

  lifecycle {
    create_before_destroy = true  # 기존 인증서 삭제 전에 새 인증서 생성
  }
}

# ACM 인증서 검증용
resource "aws_route53_record" "acm_validation" {
  for_each = {
    for dvo in aws_acm_certificate.grace_cert.domain_validation_options : dvo.domain_name => {
      name  = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  zone_id = aws_route53_zone.grace_zone.zone_id
  name    = each.value.name
  type    = each.value.type
  records = [each.value.record]
  ttl     = 300
}
