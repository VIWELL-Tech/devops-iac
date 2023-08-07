provider "aws" {
  region = "us-east-1"

}

resource "aws_s3_bucket" "destination_bucket" {
  bucket = "viwell-dev-b-media"

  versioning {
    enabled = true
  }

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["PUT", "POST", "GET", "DELETE", "HEAD"]
    allowed_origins = ["*"]
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }
}

data "aws_iam_policy_document" "bucket_policy" {
  statement {
    sid       = "AllowCloudFrontServicePrincipal"
    effect    = "Allow"
    actions   = ["s3:GetObject"]
    resources = ["arn:aws:s3:::viwell-dev-b-media/*"]

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }
  }

  statement {
    effect    = "Allow"
    actions   = ["s3:GetObject"]
    resources = ["arn:aws:s3:::viwell-dev-b-media/*"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::814880204573:role/media-resize-images-role"]
    }
  }
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.destination_bucket.id
  policy = data.aws_iam_policy_document.bucket_policy.json
}
