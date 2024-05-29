output "api_gateway_url" {
  description = "URL to invoke the API pointing to the stage"
  value       = aws_api_gateway_stage.sentimental_api.invoke_url
}