resource "aws_cloudwatch_log_group" "app_logs" {
  for_each = var.app_logs

  name              = format("/app-log/%s/%s/%s", var.service_name, var.env, each.key)
  retention_in_days = 30

  tags = {
    Name     = format("cwl-%s-%s-%s", var.service_name, var.env, each.key)
    Resource = "CloudWatchLogs"
  }
}
