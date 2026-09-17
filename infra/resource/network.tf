# ################################################################################
# VPC
# ################################################################################

resource "aws_vpc" "this" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "std01-ex8-vpc"
  }
}


# ################################################################################
# Public Subnets
# ################################################################################

resource "aws_subnet" "public" {
  for_each = {
    "ap-northeast-1a" = "10.0.1.0/24"
    "ap-northeast-1c" = "10.0.2.0/24"
    "ap-northeast-1d" = "10.0.3.0/24"
  }

  vpc_id                  = aws_vpc.this.id
  availability_zone       = each.key
  cidr_block              = each.value
  map_public_ip_on_launch = true

  tags = {
    Name                     = "std01-ex8-public-${each.key}"
    "kubernetes.io/role/elb" = "1"
  }
}


# ################################################################################
# Private Subnets
# ################################################################################

resource "aws_subnet" "private" {
  for_each = {
    "ap-northeast-1a" = "10.0.11.0/24"
    "ap-northeast-1c" = "10.0.12.0/24"
    "ap-northeast-1d" = "10.0.13.0/24"
  }

  vpc_id            = aws_vpc.this.id
  availability_zone = each.key
  cidr_block        = each.value

  tags = {
    Name                              = "std01-ex8-private-${each.key}"
    "kubernetes.io/role/internal-elb" = "1"
  }
}


# ################################################################################
# Internet Gateway
# ################################################################################

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "std01-ex8-igw"
  }
}


# ################################################################################
# Public Route Table
# ################################################################################

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = {
    Name = "std01-ex8-public-rt"
  }
}

resource "aws_route_table_association" "public" {
  for_each = aws_subnet.public

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}


# ################################################################################
# NAT Gateway
# ################################################################################

resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name = "std01-ex8-nat-eip"
  }
}

resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public["ap-northeast-1a"].id

  depends_on = [aws_internet_gateway.this]

  tags = {
    Name = "std01-ex8-nat"
  }
}


# ################################################################################
# Private Route Table
# ################################################################################

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.this.id
  }

  tags = {
    Name = "std01-ex8-private-rt"
  }
}

resource "aws_route_table_association" "private" {
  for_each = aws_subnet.private

  subnet_id      = each.value.id
  route_table_id = aws_route_table.private.id
}
