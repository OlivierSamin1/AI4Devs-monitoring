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
        "${datadog_integration_aws.integration.external_id}"
      ]
    }
  }
}

# Define the permissions Datadog needs to monitor AWS resources
data "aws_iam_policy_document" "datadog_aws_integration" {
  statement {
    actions = [
      # CloudWatch
      "cloudwatch:Get*",
      "cloudwatch:List*",
      "cloudwatch:Describe*",
      
      # EC2
      "ec2:Describe*",
      "ec2:Get*",
      
      # CloudTrail
      "cloudtrail:DescribeTrails",
      "cloudtrail:GetTrailStatus",
      "cloudtrail:LookupEvents",
      
      # Cost Explorer
      "ce:GetCostAndUsage",
      
      # Tags
      "tag:GetResources",
      "tag:GetTagKeys",
      "tag:GetTagValues",
      
      # S3
      "s3:GetBucketTagging",
      "s3:GetBucketLocation",
      "s3:ListAllMyBuckets",
      "s3:ListBucket",
      
      # RDS
      "rds:Describe*",
      "rds:List*",
      
      # ELB
      "elasticloadbalancing:Describe*",
      
      # Lambda
      "lambda:List*",
      "lambda:Get*",
      
      # SQS
      "sqs:List*",
      "sqs:Get*",
      
      # Other helpful services
      "kinesis:List*",
      "kinesis:Describe*",
      "autoscaling:Describe*",
      "support:*"
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
resource "datadog_integration_aws" "integration" {
  account_id                       = var.aws_account_id
  role_name                        = "DatadogIntegrationRole"
  filter_tags                      = ["environment:production"]
  host_tags                        = ["env:production"]
  excluded_regions                 = []
  account_specific_namespace_rules = {}
}
