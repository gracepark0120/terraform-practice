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

# A 레코드를 생성 - alias 
# zone_id : 연결할 route53 호스팅 영역. cloudfront 배포의 호스팅 영역 id 참조
# domain_name : 사용자가 연결하려는 도메인 이름
