# ./vpc.tf

# VPC
resource "aws_vpc" "vpc03" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = var.vpc_name
  }
}

# IGW
resource "aws_internet_gateway" "vpc03" {
  vpc_id = aws_vpc.vpc03.id
  tags = {
    Name = "${var.vpc_name}-igw"
  }
}

# パブリックサブネット
resource "aws_subnet" "public_subnets" {
  count             = length(var.public_subnets)
  vpc_id            = aws_vpc.vpc03.id
  cidr_block        = var.public_subnets[count.index]
  availability_zone = var.availability_zones[count.index]
  map_public_ip_on_launch = true
  
  tags = {
    Name = "${var.vpc_name}-public-subnet-${count.index + 1}"
  }
}

# プライベートサブネット
resource "aws_subnet" "private_subnets" {
  count             = length(var.private_subnets)
  vpc_id            = aws_vpc.vpc03.id
  cidr_block        = var.private_subnets[count.index]
  availability_zone = var.availability_zones[count.index]
  map_public_ip_on_launch = false
  tags = {
    Name = "${var.vpc_name}-private-subnet-${count.index + 1}"
  }
}

## ルートテーブル：
## パブリック
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc03.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpc03.id
  }
  tags = {
    Name = "${var.vpc_name}-public-rt"
  }
}

## プライベート
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc03.id
  tags = {
    Name = "${var.vpc_name}-private-rt"
  }
}

# サブネットとルートテーブル関連付け：
## パブリック
resource "aws_route_table_association" "public_rt_asso" {
  count        = length(var.public_subnets)
  subnet_id    = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public.id
}

## プライベート
resource "aws_route_table_association" "private_rt_asso" {
  count        = length(var.private_subnets)
  subnet_id    = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.private.id
}
