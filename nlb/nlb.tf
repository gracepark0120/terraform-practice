
### 8️⃣ NLB 생성 (Public Subnet에 배치) ###
resource "aws_lb" "nlb" {
  name               = "my-nlb"
  internal           = false # 인터넷 접근 가능하게
  load_balancer_type = "network"
  subnets            = [aws_subnet.public_subnet.id]

  tags = {
    Name = "MyNLB"
  }
}

### 9️⃣ NLB 타겟 그룹 생성 ###
resource "aws_lb_target_group" "nlb_tg" {
  name     = "my-nlb-tg"
  port     = 80
  protocol = "TCP"
  vpc_id   = aws_vpc.main_vpc.id
}

### 🔟 EC2를 타겟 그룹에 추가 ###
resource "aws_lb_target_group_attachment" "web" {
  target_group_arn = aws_lb_target_group.nlb_tg.arn
  target_id        = aws_instance.web.id
  port             = 80
}

### 1️⃣1️⃣ NLB 리스너 설정 ###
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.nlb.arn
  port              = 80
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nlb_tg.arn
  }
}

# https 트래픽 처리 추가
resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.nlb.arn
  port              = 443
  protocol          = "TLS"

  ssl_policy       = "ELBSecurityPolicy-2016-08"  # AWS에서 제공하는 기본 SSL 정책
  certificate_arn  = aws_acm_certificate.grace_cert.arn  # ✅ ACM 인증서 적용

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nlb_tg.arn
  }
}
