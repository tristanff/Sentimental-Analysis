output "compute_access_sg_id" {
  description = "The ID of the security group for compute access"
  value       = aws_security_group.compute_access.id
}

output "lambda_sg_id" {
  description = "The ID of the security group for Lambda functions"
  value       = aws_security_group.lambda_sg.id
}