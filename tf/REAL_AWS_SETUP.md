# Setting Up Datadog-AWS Integration with Real AWS Credentials

This guide provides step-by-step instructions to set up the Datadog-AWS integration using your real AWS credentials.

## Prerequisites

- AWS account with permissions to create IAM roles and policies
- Datadog account with API and APP keys
- AWS CLI installed and configured (optional but recommended)

## Step 1: Configure Your AWS Credentials

There are three ways to configure your AWS credentials:

### Option 1: Using the setup script

1. Run the AWS credentials setup script:
   ```bash
   ./setup-aws-credentials.sh
   ```

2. Enter your AWS Access Key ID and Secret Access Key when prompted.

### Option 2: Using environment variables

Set your AWS credentials as environment variables:
```bash
export AWS_ACCESS_KEY_ID="your_access_key"
export AWS_SECRET_ACCESS_KEY="your_secret_key"
export AWS_DEFAULT_REGION="eu-north-1"
```

### Option 3: Using the AWS CLI

If you have the AWS CLI installed, you can configure your credentials:
```bash
aws configure
```

## Step 2: Prepare Terraform Configuration

1. Make sure your Datadog API and APP keys are properly set up in terraform.tfvars:
   ```bash
   ./fix-setup.sh
   ```

2. Validate that the AWS provider in consolidated_providers.tf is using real credentials.

## Step 3: Run Terraform to Create Resources

1. Initialize Terraform:
   ```bash
   terraform init
   ```

2. Plan the changes:
   ```bash
   terraform plan
   ```

3. Apply the configuration:
   ```bash
   terraform apply
   ```

4. Confirm the apply by typing `yes` when prompted.

## Step 4: Complete AWS IAM Setup

After applying Terraform, you need to ensure the proper IAM role exists in your AWS account:

1. Log in to the AWS Management Console.
2. Navigate to IAM > Roles.
3. Verify that the "DatadogIntegrationRole" has been created.
4. Ensure the role has:
   - Trust relationship that allows Datadog's account to assume it
   - The External ID configured matches what Datadog expects
   - The proper permissions policies attached

If the role is not present, you may need to create it manually using the role_name and external_id from the Terraform output.

## Step 5: Verify Integration in Datadog

1. Log in to your Datadog account at https://app.datadoghq.eu/.
2. Navigate to Integrations > AWS.
3. Verify that your AWS account appears in the list of integrated accounts.
4. Check that the status is "Connected" and that data is flowing in.
5. Wait 10-15 minutes for initial data collection to complete.

## Step 6: View the AWS Dashboard

Access your AWS dashboard using the URL provided in the Terraform output:
```bash
terraform output datadog_dashboard_url
```

## Troubleshooting

If you encounter any issues:

1. **AWS Credentials Problems**:
   - Verify your credentials are valid and have sufficient permissions
   - Try configuring credentials using the AWS CLI
   - Check for any IAM policy restrictions on your account

2. **Role Creation Issues**:
   - Make sure you have permissions to create IAM roles
   - Create the role manually in the AWS console if needed

3. **Integration Not Working**:
   - Verify the External ID matches what Datadog expects
   - Check IAM role permissions
   - Look for errors in the Datadog AWS integration page 