variable "datadog_api_key" {
  type        = string
  description = "Datadog API key"
  sensitive   = true
}

variable "datadog_app_key" {
  type        = string
  description = "Datadog APP key"
  sensitive   = true
}

variable "aws_account_id" {
  type        = string
  description = "AWS Account ID"
}
