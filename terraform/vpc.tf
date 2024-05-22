

# VPC
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"  # Update with your desired CIDR block
  enable_dns_support = true
  enable_dns_hostnames = true
}

# Subnet
resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.1.0/24"  # Update with your desired subnet CIDR block
  availability_zone = "us-east-1a"  # Update with your desired availability zone
}