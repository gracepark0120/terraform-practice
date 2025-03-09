
### 6️⃣ 보안 그룹 설정 (최소한의 포트만 개방) ###
# ✅ NLB 보안 그룹 (외부 트래픽 허용)
resource "aws_security_group" "nlb_sg" {
  vpc_id = aws_vpc.main_vpc.id

  ingress {
    from_port   = 80  # HTTP 트래픽 허용
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # 전 세계에서 접근 가능
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "NLB-SG"
  }
}

# ✅ EC2 보안 그룹 (NLB만 허용)
resource "aws_security_group" "ec2_sg" {
  vpc_id = aws_vpc.main_vpc.id

  ingress {
    from_port       = 80  # HTTP 트래픽 허용 (NLB에서만 허용)
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.nlb_sg.id]
  }

  ingress {
    from_port   = 22  # SSH 허용 (특정 IP만 가능)
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["14.52.103.180/32"]  # 본인 IP 입력 (변경 필요)
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "EC2-SG"
  }
}