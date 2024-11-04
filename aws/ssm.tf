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
