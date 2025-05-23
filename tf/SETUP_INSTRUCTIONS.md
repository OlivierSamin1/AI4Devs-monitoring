# How to Set Up Datadog AWS Monitoring with Terraform

This guide provides step-by-step instructions to fix the Terraform configuration issues and properly set up Datadog monitoring for your AWS environment.

## Step 1: Fix Terraform Configuration Issues

1. Navigate to the `tf` directory:
   ```bash
   cd tf
   ```

2. Fix the datadog-aws-integration.tf file:
   ```bash
   ./fix-datadog-integration.sh
   ```

3. Create a consolidated provider configuration:
   ```bash
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
   }
   EOF
   ```

4. Remove any remaining provider.tf file if it exists:
   ```bash
   rm -f provider.tf
   ```

5. Update main.tf to avoid conflicts:
   ```bash
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
   ```

## Step 2: Set Up Terraform Variables

1. Run the setup script to create the terraform.tfvars file with your API keys:
   ```bash
   ./setup-terraform.sh
   ```

2. Verify that terraform.tfvars has been created with the correct values:
   ```bash
   cat terraform.tfvars
   ```

## Step 3: Initialize and Apply Terraform

1. Initialize the Terraform working directory:
   ```bash
   terraform init
   ```

2. Validate the configuration:
   ```bash
   terraform validate
   ```

3. Plan the changes:
   ```bash
   terraform plan
   ```

4. Apply the configuration:
   ```bash
   terraform apply
   ```

5. Confirm the apply by typing `yes` when prompted

## Step 4: Verify the AWS-Datadog Integration

1. Log in to your Datadog account at https://app.datadoghq.eu/
2. Navigate to Integrations > AWS
3. Verify that your AWS account appears in the list of integrated accounts
4. Check that the status is "Connected" and that data is flowing in
5. Wait 10-15 minutes for initial data collection to complete

## Step 5: Verify the EC2 Instance Setup

1. Log in to your AWS Management Console
2. Navigate to EC2 > Instances
3. Find the instance named "datadog-monitored-instance-new"
4. Verify it's in the "running" state
5. If you can connect to the instance, check the agent status:
   ```bash
   sudo datadog-agent status
   ```

## Step 6: Verify Dashboard Creation

1. In your Datadog account, navigate to Dashboards
2. Look for the "AWS Overview Dashboard"
3. Open the dashboard and verify that AWS metrics are being displayed
4. The dashboard URL will also be output by Terraform after a successful apply

## Troubleshooting

If you still encounter issues:

1. Check for syntax errors in Terraform files:
   ```bash
   terraform fmt
   ```

2. If initialization fails, try with a clean state:
   ```bash
   rm -rf .terraform* terraform.tfstate*
   ```

3. Verify that all required variables are set:
   ```bash
   grep -r "var\." --include="*.tf" .
   ```

4. Check for missing or incompatible provider versions:
   ```bash
   terraform providers
   ```

5. To apply just one component at a time, use the `-target` flag:
   ```bash
   terraform apply -target=datadog_integration_aws_account.datadog_integration
   ``` 