provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_role" "replication" {
  name = "tf-replication-role"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "s3.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "replication" {
  name        = "tf-replication-policy"
  description = "Policy for allowing S3 bucket replication"
  policy      = data.aws_iam_policy_document.replication.json
}

data "aws_iam_policy_document" "replication" {
  statement {
    actions = [
      "s3:GetBucketVersioning",
      "s3:GetObjectVersionForReplication",
      "s3:GetObjectVersionTagging",
      "s3:ListBucket",
      "s3:ReplicateDelete",
      "s3:ReplicateObject",
      "s3:ReplicateTags",
    ]

    resources = [
      "arn:aws:s3:::image-resize-prod-814880204573-us-east-1",
      "arn:aws:s3:::image-resize-prod-814880204573-us-east-1/*",
    ]
  }
}

resource "aws_iam_role_policy_attachment" "replication" {
  role       = aws_iam_role.replication.name
  policy_arn = aws_iam_policy.replication.arn
}

provider "aws" {
  alias  = "me_central"
  region = "me-central-1"
}

resource "aws_s3_bucket" "destination_bucket" {
  provider = aws.me_central

  bucket = "production-viwell-media"

  versioning {
    enabled = true
  }
}

resource "aws_s3_bucket_replication_configuration" "replication" {
  bucket = "image-resize-prod-814880204573-us-east-1"
  role   = aws_iam_role.replication.arn

  rule {
    id     = "tf-replication-rule"
    status = "Enabled"
    priority = 1
  
    filter {
      prefix = "prod/"
    }
    delete_marker_replication {
      status = "Enabled"
    }


    destination {
      bucket        = aws_s3_bucket.destination_bucket.arn
      storage_class = "STANDARD"
    }
  }
}
