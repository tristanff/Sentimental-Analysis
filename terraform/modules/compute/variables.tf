variable "lab_role_arn" {
  description = "ARN of your lab role"
  type        = string
  default     = ""
}
variable "container_image_url" {
  description = "The url of the compute containter image"
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