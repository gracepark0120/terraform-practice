### 7️⃣ EC2 인스턴스 생성 (Private Subnet에 배치) ###
resource "aws_instance" "web" {
  ami           = "ami-0fd09938053af7270" # Amazon Linux 2
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.private_subnet.id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  key_name      =  aws_key_pair.grace_key_pair.key_name # 키 패어
  iam_instance_profile = aws_iam_instance_profile.ssm_profile.name  # ✅ SSM 적용

 
  tags = {
    Name = "WebServer"
  }
}



# ssm 설정

# IAM ROlE
resource "aws_iam_role" "ssm_role" {
  name = "ssm_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_policy_attachment" "ssm_policy_attach" {
  name       = "ssm-policy-attachment"
  roles      = [aws_iam_role.ssm_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ssm_profile" {
  name = "ssm_profile"
  role = aws_iam_role.ssm_role.name
}

## SSH KEy 로컬에서 가져오는 방법
# resource "aws_key_pair" "grace_key" {
#   key_name   = "my-aws-key"                   # AWS에서 생성될 Key Pair 이름
#   public_key = file("~/.ssh/grace-aws-key.pub")  # 로컬에 있는 공개 키 사용
# }



resource "tls_private_key" "grace_ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "grace_key_pair" {
  key_name   = "grace-aws-key"
  public_key = tls_private_key.grace_ssh_key.public_key_openssh
}

# Private Key를 로컬 파일에 저장
resource "local_file" "ssh_key" {
  filename = "${path.module}/grace-aws-key.pem"
  content  = tls_private_key.grace_ssh_key.private_key_pem
}
