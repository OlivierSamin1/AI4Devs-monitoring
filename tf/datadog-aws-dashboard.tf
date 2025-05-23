resource "datadog_dashboard" "aws_dashboard" {
  title       = "AWS Overview Dashboard"
  description = "Dashboard for monitoring AWS resources"
  layout_type = "ordered"
  
  widget {
    timeseries_definition {
      title       = "EC2 CPU Utilization"
      request {
        q = "avg:aws.ec2.cpuutilization{*} by {host}"
        display_type = "line"
      }
    }
  }
  
  widget {
    timeseries_definition {
      title = "EC2 Network In/Out"
      request {
        q = "avg:aws.ec2.network_in{*} by {host}"
        display_type = "line"
      }
      request {
        q = "avg:aws.ec2.network_out{*} by {host}"
        display_type = "line"
      }
    }
  }
} 