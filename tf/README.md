# Terraform Configuration for Datadog AWS Integration

This directory contains Terraform configurations to:
1. Set up the Datadog-AWS integration
2. Install the Datadog agent on EC2 instances
3. Create a Datadog dashboard for AWS metrics

## Security Notice

These configurations require sensitive information such as API keys. **Never commit this sensitive information to version control.**

## Setup Instructions

1. Copy the sample variables file:
   ```
   cp terraform.tfvars.sample terraform.tfvars
   ```

2. Edit `terraform.tfvars` with your actual values:
   ```
   datadog_api_key = "your_actual_api_key"
   datadog_app_key = "your_actual_app_key"
   aws_account_id  = "your_actual_aws_account_id"
   ```

3. Initialize Terraform:
   ```
   terraform init
   ```

4. Validate the configuration:
   ```
   terraform validate
   ```

5. Plan the deployment:
   ```
   terraform plan
   ```

6. Apply the configuration:
   ```
   terraform apply
   ```

## Alternative: Using Environment Variables

Instead of using a .tfvars file, you can also set environment variables:

```bash
export TF_VAR_datadog_api_key="your_actual_api_key"
export TF_VAR_datadog_app_key="your_actual_app_key"
export TF_VAR_aws_account_id="your_actual_aws_account_id"
```

Then run Terraform commands as usual.

## Files

- `main.tf`: Main configuration and provider setup
- `variables.tf`: Variable definitions
- `datadog-aws-integration.tf`: AWS IAM role and Datadog integration setup
- `datadog-agent-ec2.tf`: EC2 instance with Datadog agent
- `datadog-aws-dashboard.tf`: Datadog dashboard configuration 