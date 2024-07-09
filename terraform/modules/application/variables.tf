variable "account_id" {
  description = "ID of your AWS account"
  type        = string
}
variable "region" {
  description = "Region of your deployed architecture"
  type        = string
}


variable "public_subnet_id" {
  description = "The ID of the public subnet"
  type        = string
}

variable "private_subnet_id" {
  description = "The ID of the private subnet"
  type        = string
}

variable "lambda_sg" {
  description = "The ID of the security group for Lambda functions"
  type        = string
}