provider "aws" {
  region = "us-east-1" 

}

data "aws_iam_policy_document" "s3_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["arn:aws:s3:::${var.bucket_name}/*"]

    principals {
      identifiers = ["cloudfront.amazonaws.com"]
      type        = "Service"
    }
  }
}
resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name = var.bucket_domain_name
    origin_id   = var.bucket_name

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path
    }
  }
  custom_error_response {
    error_caching_min_ttl = 300 # optional: time in seconds that the error response will be cached in CloudFront. Default is 300.
    error_code            = 403
    response_code         = 200
    response_page_path    = "/index.html"
  }
  enabled             = true
  is_ipv6_enabled     = true
  comment             = "Distribution for content delivery of portal on test environment"
  default_root_object = "index.html"

  aliases = [var.custom_domain_name]
  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = var.bucket_name

    # Referencing the managed policies directly:
    cache_policy_id          = "658327ea-f89d-4fab-a63d-7e88639e58f6"  # ID for the managed CachingOptimized policy
    #origin_request_policy_id = "216adef6-5c7f-47e4-b989-5492eafa07d9"  # ID for the managed AllViewer policy
    compress                 = false  # Disable auto compression
    viewer_protocol_policy = "allow-all"
  }
    viewer_certificate {
    acm_certificate_arn      = var.acm_certificate_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2019"
  }
  price_class = "PriceClass_100"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
}

resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = "Cloudfront origin access identity"
}
