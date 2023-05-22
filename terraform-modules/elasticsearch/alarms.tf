resource "aws_sns_topic" "sns" {
  name = "${var.cluster_name}-opsgenie"
}

resource "aws_cloudwatch_metric_alarm" "cluster_status_is_red" {
  alarm_name          = "${var.cluster_name}-ElasticSearch-ClusterStatusIsRed"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "ClusterStatus.red"
  namespace           = "AWS/ES"
  period              = "60"
  statistic           = "Maximum"
  threshold           = "1"
  alarm_description   = "Average elasticsearch cluster status is in red over last 1 minutes"
  alarm_actions       = [aws_sns_topic.sns.arn]
  ok_actions          = [aws_sns_topic.sns.arn]
  treat_missing_data  = "ignore"

  dimensions = {
    DomainName = var.cluster_name
    ClientId   = data.aws_caller_identity.current.account_id
  }
}


resource "aws_cloudwatch_metric_alarm" "free_storage_space_too_low" {
  alarm_name = "${var.cluster_name}-ElasticSearch-FreeStorageSpaceTooLow"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods = "1"
  metric_name = "FreeStorageSpace"
  namespace = "AWS/ES"
  period = "60"
  statistic = "Minimum"
  threshold = "80"
  alarm_description = "Average elasticsearch free storage space over last 1 minutes is too low"
  alarm_actions = [aws_sns_topic.sns.arn]
  ok_actions = [aws_sns_topic.sns.arn]
  treat_missing_data = "ignore"

  dimensions = {
    DomainName = var.cluster_name
    ClientId = data.aws_caller_identity.current.account_id
  }
}


resource "aws_cloudwatch_metric_alarm" "automated_snapshot_failure" {
  alarm_name          = "${var.cluster_name}-ElasticSearch-AutomatedSnapshotFailure"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "AutomatedSnapshotFailure"
  namespace           = "AWS/ES"
  period              = "60"
  statistic           = "Maximum"
  threshold           = "1"
  alarm_description   = "Elasticsearch automated snapshot failed over last 1 minutes"
  alarm_actions       = [aws_sns_topic.sns.arn]
  ok_actions          = [aws_sns_topic.sns.arn]
  treat_missing_data  = "ignore"

  dimensions = {
    DomainName = var.cluster_name
    ClientId   = data.aws_caller_identity.current.account_id
  }
}