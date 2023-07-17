provider "aws" {
  region = "me-central-1"
}

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir = "lambda_function"
  output_path = "lambda_function_payload.zip"
}

resource "aws_iam_role" "lambda_role" {
  name = "lambda_backup_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "lambda_policy" {
  name = "lambda_policy"
  role = aws_iam_role.lambda_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*"
    },
    {
      "Effect": "Allow",
      "Action": "s3:PutObject",
      "Resource": "arn:aws:s3:::viwell-github-backup/*"
    },
    {
      "Effect": "Allow",
            "Effect": "Allow",
            "Action": "secretsmanager:GetSecretValue",
            "Resource": "arn:aws:secretsmanager:*:*:secret:*"
    }
  ]
}
EOF
}


resource "aws_s3_bucket" "bucket" {
  bucket = "viwell-github-backup"
  acl    = "private"
}

resource "aws_lambda_function" "backup" {
  filename      = data.archive_file.lambda_zip.output_path
  function_name = "github_backup"
  role          = aws_iam_role.lambda_role.arn
  handler       = "lambda_function.lambda_handler"
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  runtime       = "python3.8"
  timeout       = "300"
}

resource "aws_cloudwatch_event_rule" "daily" {
  name                = "backup_daily"
  schedule_expression = "rate(1 day)"
}

resource "aws_cloudwatch_event_target" "backup_daily" {
  rule      = aws_cloudwatch_event_rule.daily.name
  target_id = "github_backup"
  arn       = aws_lambda_function.backup.arn
}

resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.backup.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.daily.arn
}
