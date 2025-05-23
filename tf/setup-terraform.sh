#!/bin/bash

# Load variables from .env file
if [ -f "../.env" ]; then
  echo "Loading variables from .env file..."
  export $(grep -v '^#' ../.env | xargs)
else
  echo "Error: .env file not found!"
  exit 1
fi

# Check if required variables are set
if [ -z "$DATADOG_API_KEY" ] || [ -z "$DATADOG_APP_KEY" ] || [ -z "$AWS_ACCOUNT_ID" ]; then
  echo "Error: Required environment variables are missing!"
  echo "Make sure DATADOG_API_KEY, DATADOG_APP_KEY, and AWS_ACCOUNT_ID are set in the .env file."
  exit 1
fi

# Create terraform.tfvars file
echo "Creating terraform.tfvars file..."
cat > terraform.tfvars << EOF
datadog_api_key = "${DATADOG_API_KEY}"
datadog_app_key = "${DATADOG_APP_KEY}"
aws_account_id  = "${AWS_ACCOUNT_ID}"
EOF

echo "terraform.tfvars file created successfully."
echo "You can now run: terraform init && terraform plan"

# Make sure terraform.tfvars is in .gitignore
if ! grep -q "terraform.tfvars" ../.gitignore; then
  echo "Adding terraform.tfvars to .gitignore..."
  echo -e "\n# Terraform secrets\ntf/terraform.tfvars\n*.tfstate\n*.tfstate.backup\n.terraform/" >> ../.gitignore
fi

echo "Terraform setup complete!" 