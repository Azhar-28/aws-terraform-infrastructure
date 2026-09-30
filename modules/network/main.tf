resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "AWS-Infrastructure-VPC"
  }

}

resource "aws_subnet" "public_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet_a_cidr
  availability_zone = "ap-south-1a"

  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet"
  }

}

resource "aws_subnet" "public_b" {
  vpc_id = aws_vpc.main.id
  cidr_block = var.public_subnet_b_cidr
  availability_zone = "ap-south-1b"

  map_public_ip_on_launch = true

}

resource "aws_subnet" "private_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_a_cidr
  availability_zone = "ap-south-1a"

  tags = {
    Name = "private-subnet"
  }

}

resource "aws_subnet" "private_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_b_cidr
  availability_zone = "ap-south-1b"

  tags = {
    Name = "private-subnet"
  }

}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "IGW"
  }

}

resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-rt"
  }

}

resource "aws_route_table_association" "public_a" {
  route_table_id = aws_route_table.public-rt.id
  subnet_id      = aws_subnet.public_a.id

}

resource "aws_route_table_association" "public_b" {
  route_table_id = aws_route_table.public-rt.id
  subnet_id      = aws_subnet.public_b.id

}



resource "aws_route_table" "private-rt" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "private-rt"
  }

}

resource "aws_route_table_association" "private_a" {
  route_table_id = aws_route_table.private-rt.id
  subnet_id      = aws_subnet.private_a.id

}

resource "aws_route_table_association" "private_b" {
  route_table_id = aws_route_table.private-rt.id
  subnet_id      = aws_subnet.private_b.id

}