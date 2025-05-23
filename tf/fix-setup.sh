#!/bin/bash

echo "Loading variables from .env file..."
source ../.env

# Fix any formatting issues with the AWS account ID
AWS_ACCOUNT_ID=$(echo $AWS_ACCOUNT_ID | tr -d '\r' | tr -d '\n' | tr -d ' ')

# Create terraform.tfvars file
echo "Creating terraform.tfvars file..."
cat > terraform.tfvars << EOF
datadog_api_key = "${DATADOG_API_KEY}"
datadog_app_key = "${DATADOG_APP_KEY}"
aws_account_id  = "${AWS_ACCOUNT_ID}"
EOF

echo "terraform.tfvars file created successfully."
echo "You can now run: terraform init && terraform plan" 