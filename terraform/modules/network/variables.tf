variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
  default     = "CC-2024Q1-G2"
}
variable "vpc_cidr" {
  description = "CIDR of the VPC"
  type        = string
  default     = "10.0.0.0/16"
}
variable "public_cidr" {
  description = "CIDR of the public subnet"
  type        = string
  default     = "10.0.1.0/24"
}
variable "public_az" {
  description = "Name of the public availability zone"
  type        = string
  default     = "us-east-1a"
}