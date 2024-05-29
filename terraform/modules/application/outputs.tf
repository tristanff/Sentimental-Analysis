output "api_gateway_url" {
  description = "URL to invoke the API pointing to the stage"
  value       = aws_api_gateway_deployment.sentimental_api.invoke_url
}