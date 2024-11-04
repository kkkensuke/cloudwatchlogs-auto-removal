variable "env" {
  type    = string
  default = "dev"
}

variable "service_name" {
  type    = string
  default = "cwlogs-autoremoval"
}

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
