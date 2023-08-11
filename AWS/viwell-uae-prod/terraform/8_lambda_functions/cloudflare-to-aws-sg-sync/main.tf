provider "aws" {
  region = "me-central-1"

}
resource "aws_iam_policy" "describe_sg_policy" {
  name        = "DescribeSecurityGroupsPolicy"
  description = "IAM policy to describe security groups"
  policy      = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action   = [
          "ec2:DescribeSecurityGroups",
          "ec2:AuthorizeSecurityGroupIngress",
          "ec2:RevokeSecurityGroupIngress"
        ],
        Effect   = "Allow",
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role" "lambda_cloudflare" {
  name = "lambda_cloudflare_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Principal = {
          Service = "lambda.amazonaws.com"
        },
        Effect = "Allow",
        Sid    = ""
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_cloudflare_policy" {
  policy_arn = aws_iam_policy.describe_sg_policy.arn
  role       = aws_iam_role.lambda_cloudflare.name
}

resource "aws_lambda_function" "cloudflare_ips_updater" {
  function_name = "CloudflareIPsUpdater"
  role          = aws_iam_role.lambda_cloudflare.arn
  handler       = "update_sg_from_cloudflare.lambda_handler"
  runtime       = "python3.10"
  filename      = "function.zip"
  timeout       = 300  # Set the timeout value in seconds (e.g., 5 minutes)

  environment {
    variables = {
      # SECURITY_GROUP_ID modified to contain a comma-separated list of security group IDs
      SECURITY_GROUP_ID = "sg-0d5dca8d90bd1410c,sg-02ea626c188a5353c" 
      REGION_NAME       = "me-central-1"
    }
  }
}

resource "aws_cloudwatch_event_rule" "daily_trigger" {
  schedule_expression = "rate(1 day)"
}

resource "aws_cloudwatch_event_target" "trigger_lambda" {
  rule      = aws_cloudwatch_event_rule.daily_trigger.name
  target_id = "TriggerLambda"
  arn       = aws_lambda_function.cloudflare_ips_updater.arn
}

resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.cloudflare_ips_updater.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.daily_trigger.arn
}

