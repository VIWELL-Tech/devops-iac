provider "aws" {
  alias  = "me_central"
  region = "me-central-1"
}

resource "aws_s3_bucket" "destination_bucket" {
  provider = aws.me_central

  bucket = "production-viwell-media"
  acl    = "public-read"  # tmp for now to make it compatiable with current communication from the code

  versioning {
    enabled = true
  }
}

resource "aws_s3_bucket_cors" "bucket_cors" {
  bucket = aws_s3_bucket.destination_bucket.bucket

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
    resources = ["arn:aws:s3:::production-viwell-media/*"]

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = ["arn:aws:cloudfront::814880204573:distribution/E23P1XMVVLXPQX"]
    }
  }

  statement {
    sid       = "4"
    effect    = "Allow"
    actions   = ["s3:GetObject"]
    resources = ["arn:aws:s3:::production-viwell-media/*"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::cloudfront:user/CloudFront Origin Access Identity E3U1MAYPBREW37"]
    }
  }

  statement {
    effect    = "Allow"
    actions   = ["s3:GetObject"]
    resources = ["arn:aws:s3:::production-viwell-media/*"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::814880204573:role/media-resize-images-role"]
    }
  }

  statement {
    sid       = "8"
    effect    = "Allow"
    actions   = ["s3:GetObject"]
    resources = ["arn:aws:s3:::production-viwell-media/*"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::cloudfront:user/CloudFront Origin Access Identity E2K1N8DYNQKMG9"]
    }
  }
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.destination_bucket.id
  policy = data.aws_iam_policy_document.bucket_policy.json
}
