provider "aws" {
  region = "us-east-1"
  access_key = "AKIA33OVFE4O4756TFYW"
  secret_key = "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"
}

resource "aws_s3_bucket" "bucket" {
  bucket = "portal-dev-b.viwell.app"
  
  website {
    index_document = "index.html"
    error_document = "error.html"
  }
}

resource "aws_s3_bucket_public_access_block" "access_block" {
  bucket = aws_s3_bucket.bucket.id

  block_public_acls   = true
  block_public_policy = true
  ignore_public_acls  = true
  restrict_public_buckets = true
}

data "aws_iam_policy_document" "bucket_policy" {
  statement {
    sid       = "1"
    effect    = "Allow"
    actions   = ["s3:GetObject"]
    resources = ["arn:aws:s3:::portal-dev-b.viwell.app/*"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::cloudfront:user/CloudFront Origin Access Identity E1OG1NUJ3T7OKL"]
    }
  }
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.bucket.id
  policy = data.aws_iam_policy_document.bucket_policy.json
}
