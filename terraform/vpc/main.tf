# VPC
resource "aws_vpc" "my_vpc" {
  cidr_block           = "10.0.0.0/16" # Update with your desired CIDR block
  enable_dns_support   = true
  enable_dns_hostnames = true
}

# Subnet
resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.1.0/24" # Update with your desired subnet CIDR block
  availability_zone = "us-east-1a"  # Update with your desired availability zone
}

# Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.my_vpc.id
}

# Route Table
resource "aws_route_table" "main" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
}

resource "aws_route_table_association" "main" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.main.id
}

resource "aws_security_group" "compute_instance" {
  name        = "ComputeInstanceSecurityGroup"
  description = "Allow compute instance to access API Gateway"
  vpc_id      = aws_subnet.public_subnet.vpc_id

  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}






