# Output the Datadog installation command for reference (without exposing the API key)
output "datadog_install_command" {
  value = "DD_API_KEY=<YOUR_API_KEY> DD_SITE=\"datadoghq.eu\" bash -c \"$(curl -L https://s3.amazonaws.com/dd-agent/scripts/install_script_agent7.sh)\""
  description = "Command to install Datadog agent (replace <YOUR_API_KEY> with your actual API key)"
}

# Output the dashboard URL after creation
output "datadog_dashboard_url" {
  value = try("https://app.datadoghq.eu/dashboard/${datadog_dashboard.aws_dashboard.id}", "Dashboard not created yet")
  description = "URL to access the created Datadog dashboard"
}
