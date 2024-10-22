data "aws_availability_zones" "available" {}

resource "aws_vpc" "custom" {
  cidr_block = "10.0.0.0/16"
}


resource "aws_subnet" "private-1" {
  vpc_id     = aws_vpc.custom.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "eu-central-1a"

  tags = {
    Name = "private-subnet-1a"
  }
}

resource "aws_subnet" "private-2" {
  vpc_id     = aws_vpc.custom.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "eu-central-1b"

  tags = {
    Name = "private-subnet-1b"
  }
}


resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.custom.id
  cidr_block              = "10.0.3.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.custom.id

  tags = {
    Name = "prod-internet-gatway"
  }
}

resource "aws_route_table" "example" {
  vpc_id = aws_vpc.custom.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "public-subnet-route"
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.example.id
}