#!/bin/bash

echo "Setting up AWS credentials..."

# Prompt for AWS credentials
read -p "Enter your AWS Access Key ID: " AWS_ACCESS_KEY_ID
read -sp "Enter your AWS Secret Access Key: " AWS_SECRET_ACCESS_KEY
echo ""
read -p "Enter your AWS Session Token (leave empty if not using temporary credentials): " AWS_SESSION_TOKEN

# Create AWS credentials directory if it doesn't exist
mkdir -p ~/.aws

# Write credentials to file
cat > ~/.aws/credentials << EOF
[default]
aws_access_key_id = ${AWS_ACCESS_KEY_ID}
aws_secret_access_key = ${AWS_SECRET_ACCESS_KEY}
EOF

# Add session token if provided
if [ ! -z "$AWS_SESSION_TOKEN" ]; then
  echo "aws_session_token = ${AWS_SESSION_TOKEN}" >> ~/.aws/credentials
fi

# Write config file
cat > ~/.aws/config << EOF
[default]
region = eu-north-1
output = json
EOF

echo "AWS credentials have been configured successfully."
echo "You can now run: terraform init && terraform plan" 