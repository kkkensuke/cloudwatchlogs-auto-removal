# cloudwatchlogs-auto-removal
This repository contains terraform code for creating CloudWatchLogs with auto-removal setting

## HOW IT WORKS
Terraform code from this repository creates cloudwatch log groups and parameter at ssm-parameter store.
1. Set your application (or any) log name / log file name at `variables.tf`
```
variable "app_logs" {
  type = map(string)
  default = {
    "info_log"      = "log-file-name"
    "error_log"     = "log-file-name"
    "feature_1_log" = "log-file-name"
    "feature_2_log" = "log-file-name"
    // Add more log files here
  }
}

```
2. Define cloudwatch log group for each log.
```
resource "aws_cloudwatch_log_group" "app_logs" {
  for_each = var.app_logs

  name              = format("/app-log/%s/%s/%s", var.service_name, var.env, each.key)
  retention_in_days = 30

  tags = {
    Name     = format("cwl-%s-%s-%s", var.service_name, var.env, each.key)
    Resource = "CloudWatchLogs"
  }
}
```
3. Configure ssm parameter for CloudWatch Agent configuration file. Contents of this file is an actual configuration you set to CW Agent Config file.
```
resource "aws_ssm_parameter" "cwlogs_app_logs" {
  name = format("AmazonCloudWatchLogs-%s-%s", var.service_name, var.env)
  type = "String"
  tier = "Standard" // or "Advanced"
  value = jsonencode({
    "logs" : {
      "logs_collected" : {
        "files" : {
          "collect_list" : [for key, filename in var.app_logs :
            {
              "file_path" : "<Path to log directory>\\${filename}.log*"
              "log_group_name" : format("/app-log/%s/%s/%s", var.service_name, var.env, key),
              "log_stream_name" : "{instance_id}",
              "auto_removal" : "true"
            }
          ]
        }
      }
    }
  })
}
```

4. Execute Rum Command from AWS Console or via AWS CLI with `AmazonCloudWatch-ManageAgent` document.
  - select ssm parameter name at `command parameter` section.

