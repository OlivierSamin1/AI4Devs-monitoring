terraform {
  required_providers {
    datadog = {
      source = "DataDog/datadog"
    }
    aws = {
      source = "hashicorp/aws"
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

# Define the IAM policy document that allows Datadog to assume a role in AWS
data "aws_iam_policy_document" "datadog_aws_integration_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::464622532012:root"] # Datadog's account ID
    }
    condition {
      test     = "StringEquals"
      variable = "sts:ExternalId"
      values = [
        "${datadog_integration_aws_account.datadog_integration.auth_config.aws_auth_config_role.external_id}"
      ]
    }
  }
}

# Define the permissions Datadog needs to monitor AWS resources
data "aws_iam_policy_document" "datadog_aws_integration" {
  statement {
    actions = [
      "cloudwatch:Get*",
      "cloudwatch:List*",
      "ec2:Describe*",
      "support:*",
      "tag:GetResources",
      "tag:GetTagKeys",
      "tag:GetTagValues"
    ]
    resources = ["*"]
  }
}

# Create the IAM policy for Datadog
resource "aws_iam_policy" "datadog_aws_integration" {
  name   = "DatadogAWSIntegrationPolicy"
  policy = data.aws_iam_policy_document.datadog_aws_integration.json
}

# Create the IAM role for Datadog
resource "aws_iam_role" "datadog_aws_integration" {
  name               = "DatadogIntegrationRole"
  description        = "Role for Datadog AWS Integration"
  assume_role_policy = data.aws_iam_policy_document.datadog_aws_integration_assume_role.json
}

# Attach the custom policy to the role
resource "aws_iam_role_policy_attachment" "datadog_aws_integration" {
  role       = aws_iam_role.datadog_aws_integration.name
  policy_arn = aws_iam_policy.datadog_aws_integration.arn
}

# Attach the AWS SecurityAudit policy to the role
resource "aws_iam_role_policy_attachment" "datadog_aws_integration_security_audit" {
  role       = aws_iam_role.datadog_aws_integration.name
  policy_arn = "arn:aws:iam::aws:policy/SecurityAudit"
}

# Configure the Datadog-AWS integration
resource "datadog_integration_aws_account" "datadog_integration" {
  account_tags   = ["environment:production"]
  aws_account_id = var.aws_account_id
  aws_partition  = "aws"
  aws_regions {
    include = ["eu-north-1"]
  }
  auth_config {
    aws_auth_config_role {
      role_name = "DatadogIntegrationRole"
    }
  }
  resources_config {
    cloud_security_posture_management_collection = true
    extended_collection                          = true
  }
  logs_config {
    lambda_forwarder {
    }
  }
  metrics_config {
    namespace_filters {
    }
  }
} 