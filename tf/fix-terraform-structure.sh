#!/bin/bash

echo "Fixing Terraform configuration structure..."

# Create a consolidated providers file
cat > consolidated_providers.tf << EOF
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

provider "datadog" {
  api_key = var.datadog_api_key
  app_key = var.datadog_app_key
}

provider "aws" {
  region = "eu-north-1"
  alias  = "eu-north-1"
}

provider "aws" {
  region = "us-east-1"
  alias  = "us-east-1"
}

# Default provider (use eu-north-1)
provider "aws" {
  region = "eu-north-1"
}
EOF

# Update references in datadog-agent-ec2.tf to use a different name for the instance
sed -i 's/resource "aws_instance" "datadog_monitored_instance"/resource "aws_instance" "datadog_monitored_instance_new"/' datadog-agent-ec2.tf

# Remove the provider configuration from datadog-aws-integration.tf
sed -i '/terraform {/,/}/d' datadog-aws-integration.tf
sed -i '/provider "datadog" {/,/}/d' datadog-aws-integration.tf
sed -i '/provider "aws" {/,/}/d' datadog-aws-integration.tf

# Remove the existing provider.tf
rm -f provider.tf

# Simplify main.tf to just outputs
cat > main.tf << EOF
# Output the Datadog installation command for reference (without exposing the API key)
output "datadog_install_command" {
  value = "DD_API_KEY=<YOUR_API_KEY> DD_SITE=\"datadoghq.eu\" bash -c \"\$(curl -L https://s3.amazonaws.com/dd-agent/scripts/install_script_agent7.sh)\""
  description = "Command to install Datadog agent (replace <YOUR_API_KEY> with your actual API key)"
}

# Output the dashboard URL after creation
output "datadog_dashboard_url" {
  value = "https://app.datadoghq.eu/dashboard/\${datadog_dashboard.aws_dashboard.id}"
  description = "URL to access the created Datadog dashboard"
}
EOF

echo "Terraform configuration fixed successfully!"
echo "You can now run: terraform init && terraform plan" 