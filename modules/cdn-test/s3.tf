resource "aws_s3_bucket" "this" { ## 버킷 추가
  bucket = var.bucket_name

  tags = {
    Name        = var.bucket_name
  }
}

# 버킷 정책
data "aws_iam_policy_document" "this" { ## 버킷 정책
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.this.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.this.iam_arn] 
    }
  }
}

resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.id
  policy = data.aws_iam_policy_document.this.json
}

resource "aws_s3_bucket_cors_configuration" "this" { ## 모든 출처에서 GET PUT POST 요청 허용, 모든 헤더 허용
  bucket = aws_s3_bucket.this.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["PUT", "POST","GET"]
    allowed_origins = ["*"]
    max_age_seconds = 3000
  }
}

resource "aws_s3_bucket_ownership_controls" "this" { ## 버킷 소유권 설정, enable_aws_s3_public이 true일 경우에만 적용됨
  count  = var.enable_aws_s3_public ? 1 : 0
  bucket = aws_s3_bucket.this.id
  rule {
    object_ownership = var.aws_s3_bucket_ownership_controls
  }
}

resource "aws_s3_bucket_public_access_block" "this" { ## S3 버킷에 대한 퍼블릭 접근을 차단, enable_aws_s3_public이 true일 경우에만 설정
  count  = var.enable_aws_s3_public ? 1 : 0
  bucket = aws_s3_bucket.this.id

  block_public_acls       = var.aws_s3_bucket_public_access_block
  block_public_policy     = var.aws_s3_bucket_public_access_block
  ignore_public_acls      = var.aws_s3_bucket_public_access_block
  restrict_public_buckets = var.aws_s3_bucket_public_access_block
}

resource "aws_s3_bucket_acl" "this" { ## acl 설정
  count  = var.enable_aws_s3_public ? 1 : 0 
  depends_on = [
    aws_s3_bucket_ownership_controls.this,
    aws_s3_bucket_public_access_block.this,
  ]

  bucket = aws_s3_bucket.this.id
  acl    = var.aws_s3_bucket_acl
}


