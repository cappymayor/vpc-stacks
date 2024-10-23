# Create a custom VPC with a defined network
resource "aws_vpc" "custom" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "custom-vpc"
  }
}

# Create a subnet in an AZ with its defined network from the overall VPC network
resource "aws_subnet" "public_1" {
  vpc_id                  = aws_vpc.custom.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "eu-central-1a"

  tags = {
    Name = "public-subnet-1a"
  }
}

# Create a subnet in an AZ with its defined network from the overall VPC network
resource "aws_subnet" "public_2" {
  vpc_id                  = aws_vpc.custom.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "eu-central-1b"

  tags = {
    Name = "public-subnet-1b"
  }
}

# Create an Internet Gateway to allow public communication to our VPC
resource "aws_internet_gateway" "public_ig" {
  vpc_id = aws_vpc.custom.id

  tags = {
    Name = "custom-internet-gatway"
  }
}

# Create route tables to route public communication from our public subnet to the public.
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.custom.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.public_ig.id
  }

  tags = {
    Name = "public-subnet-route-table"
  }
}

# Binding our route table to a specific subnet
resource "aws_route_table_association" "public_subnet_associate_1" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.public_rt.id
}

# Binding our route table to a specific subnet
resource "aws_route_table_association" "public_subnet_associate_2" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.public_rt.id
}

# Create a subnet in an AZ with its defined network from the overall VPC network
resource "aws_subnet" "private_1" {
  vpc_id            = aws_vpc.custom.id
  cidr_block        = "10.0.10.0/24"
  availability_zone = "eu-central-1a"

  tags = {
    Name = "private-subnet-1a"
  }
}

# Create a subnet in an AZ with its defined network from the overall VPC network
resource "aws_subnet" "private_2" {
  vpc_id            = aws_vpc.custom.id
  cidr_block        = "10.0.15.0/24"
  availability_zone = "eu-central-1b"

  tags = {
    Name = "private-subnet-1b"
  }
}