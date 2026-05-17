#######################################################################
#Resource-01:VPC
#######################################################################
resource "aws_vpc" "vpc" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"
  enable_dns_support = true
  enable_dns_hostnames = true
  lifecycle {
    prevent_destroy = false
  }

  tags = merge(var.tags, {env="${var.environment_name}"})
}

#######################################################################
#Resource-02:Internet gateway
#######################################################################
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = merge(var.tags, {env="${var.environment_name}"})
}

#######################################################################
#Resource-03:Public Subnet
#######################################################################
resource "aws_subnet" "public_subnet" {
  for_each = {for idx, az in local.azs : az => local.public_subnets[idx]}
  vpc_id     = aws_vpc.vpc.id
  availability_zone = each.key
  cidr_block = each.value
  map_public_ip_on_launch = true

  tags = merge(var.tags, {env="${var.environment_name}"})
}

#######################################################################
#Resource-04:Private subnet
#######################################################################
resource "aws_subnet" "private_subnet" {
  for_each = {for idx, az in local.azs : az => local.private_subnets[idx]}
  vpc_id     = aws_vpc.vpc.id
  availability_zone = each.key
  cidr_block = each.value

  tags = merge(var.tags, {env="${var.environment_name}"})
}

#######################################################################
#Resource-05:Elastic IP for nat gateway
#######################################################################
resource "aws_eip" "eip" {
  depends_on = [ aws_internet_gateway.igw ]

  tags = merge(var.tags, {env="${var.environment_name}"})
}

#######################################################################
#Resource-06:Nat Gateway
#######################################################################
resource "aws_nat_gateway" "aws_nat_gateway" {
  allocation_id = aws_eip.eip.id
  subnet_id     = values(aws_subnet.public_subnet)[0].id

  tags = merge(var.tags, {env="${var.environment_name}"})
  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.igw]
}

#######################################################################
#Resource-07:Public route table
#######################################################################
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = merge(var.tags, {env="${var.environment_name}"})
}

#######################################################################
#Resource-08:Public route table associate to public subnet
#######################################################################
resource "aws_route_table_association" "public_rt_association" {
  for_each = aws_subnet.public_subnet
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public_rt.id
}

#######################################################################
#Resource-09:Private route table
#######################################################################
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ngw.id
  }

  tags = merge(var.tags, {env="${var.environment_name}"})
}

#######################################################################
#Resource-10:Private Route table associate to private subnet
#######################################################################
resource "aws_route_table_association" "public_rt_association" {
  for_each = aws_subnet.private_subnet
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private_rt.id
}