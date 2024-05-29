variable "account_id" {
  description = "ID of your AWS account"
  type        = string
  default     = ""
}
variable "api_gateway_url" {
  description = "URL to invoke the API pointing to the stage"
  type        = string
  default     = ""
}
variable "subnet_ids" {
  description = "IDs of subnets"
  type        = list(string)
  default     = []
}
variable "region" {
  description = "Region of your deployed architecture"
  type        = string
}