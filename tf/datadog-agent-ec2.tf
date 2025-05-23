resource "aws_instance" "datadog_monitored_instance_new" {
  ami           = "ami-0989fb15ce71ba39e" # Amazon Linux 2 AMI in eu-north-1
  instance_type = "t3.micro"
  
  tags = {
    Name        = "datadog-monitored-instance"
    Environment = "production"
    Monitoring  = "datadog"
  }
  
  user_data = <<-EOF
    #!/bin/bash
    
    # Store API key securely in AWS Systems Manager Parameter Store
    aws ssm put-parameter \
      --name "/datadog/api_key" \
      --value "${var.datadog_api_key}" \
      --type "SecureString" \
      --overwrite
    
    # Retrieve the API key securely
    DD_API_KEY=$(aws ssm get-parameter --name "/datadog/api_key" --with-decryption --query "Parameter.Value" --output text)
    
    # Install the Datadog Agent
    DD_SITE="datadoghq.eu" DD_API_KEY=$DD_API_KEY bash -c "$(curl -L https://s3.amazonaws.com/dd-agent/scripts/install_script_agent7.sh)"
    
    # Configure the agent with tags
    echo "tags:" >> /etc/datadog-agent/datadog.yaml
    echo "  - env:production" >> /etc/datadog-agent/datadog.yaml
    echo "  - service:web-app" >> /etc/datadog-agent/datadog.yaml
    
    # Restart the agent to apply changes
    systemctl restart datadog-agent
  EOF
  
  # IAM role for SSM access
  iam_instance_profile = aws_iam_instance_profile.datadog_instance_profile.name
  
  # Allow the instance to reach Datadog servers
  vpc_security_group_ids = [aws_security_group.datadog_agent.id]
}

# IAM role for EC2 to access SSM
resource "aws_iam_role" "datadog_instance_role" {
  name = "DatadogInstanceRole"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

# Attach SSM policies to the role
resource "aws_iam_role_policy_attachment" "ssm_managed_instance" {
  role       = aws_iam_role.datadog_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# Create instance profile
resource "aws_iam_instance_profile" "datadog_instance_profile" {
  name = "DatadogInstanceProfile"
  role = aws_iam_role.datadog_instance_role.name
}

resource "aws_security_group" "datadog_agent" {
  name        = "datadog-agent-sg"
  description = "Security group for instances with Datadog agent"
  
  # Allow outbound traffic to Datadog servers
  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTPS outbound to Datadog"
  }
} 