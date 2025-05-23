terraform {
  required_version = ">= 1.0.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
    datadog = {
      source  = "DataDog/datadog"
      version = "~> 3.33.0"
    }
  }
}

# AWS Provider is configured in datadog-aws-integration.tf
# Datadog Provider is configured in datadog-aws-integration.tf

# Output the Datadog installation command for reference (without exposing the API key)
output "datadog_install_command" {
  value = "DD_API_KEY=<YOUR_API_KEY> DD_SITE=\"datadoghq.eu\" bash -c \"$(curl -L https://s3.amazonaws.com/dd-agent/scripts/install_script_agent7.sh)\""
  description = "Command to install Datadog agent (replace <YOUR_API_KEY> with your actual API key)"
}

# Output the dashboard URL after creation
output "datadog_dashboard_url" {
  value = "https://app.datadoghq.eu/dashboard/${datadog_dashboard.aws_dashboard.id}"
  description = "URL to access the created Datadog dashboard"
}
