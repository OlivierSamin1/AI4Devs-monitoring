resource "datadog_dashboard" "aws_dashboard" {
  title       = "AWS Overview Dashboard"
  description = "Dashboard for monitoring AWS resources"
  layout_type = "ordered"
  
  widget {
    group_definition {
      title       = "EC2 Instances"
      layout_type = "ordered"
      
      widget {
        timeseries_definition {
          title       = "EC2 CPU Utilization"
          title_size  = "16"
          title_align = "left"
          show_legend = true
          
          request {
            q = "avg:aws.ec2.cpuutilization{*} by {host}"
            display_type = "line"
          }
          
          yaxis {
            label     = "CPU %"
            min       = "0"
            max       = "100"
            include_zero = true
          }
        }
      }
      
      widget {
        timeseries_definition {
          title       = "EC2 Network In/Out"
          title_size  = "16"
          title_align = "left"
          show_legend = true
          
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
  }
  
  widget {
    group_definition {
      title       = "Resource Status"
      layout_type = "ordered"
      
      widget {
        hostmap_definition {
          title = "EC2 Status"
          no_group_hosts = true
          no_metric_hosts = false
          
          request {
            fill {
              q = "avg:aws.ec2.cpuutilization{*} by {host}"
            }
          }
          
          style {
            palette      = "green_to_orange"
            palette_flip = false
          }
        }
      }
    }
  }
  
  widget {
    group_definition {
      title       = "AWS Billing"
      layout_type = "ordered"
      
      widget {
        timeseries_definition {
          title       = "Estimated Monthly Bill"
          title_size  = "16"
          title_align = "left"
          show_legend = true
          
          request {
            q = "avg:aws.billing.estimated_charges{*}"
            display_type = "area"
          }
        }
      }
    }
  }
} 