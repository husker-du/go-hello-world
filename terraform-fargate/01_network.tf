# This block will grab availability zones that are available to your account.
data "aws_availability_zones" "available_zones" {
  state = "available"
}

# High availability VPC
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags                 = var.tags
}

# Public subnet exposed to internet
resource "aws_subnet" "public" {
  for_each          = { for i in [1, 2] : i => cidrsubnet(aws_vpc.vpc.cidr_block, 8, i) }
  cidr_block        = each.value
  availability_zone = data.aws_availability_zones.available_zones.names[tonumber(each.key) - 1]
  vpc_id            = aws_vpc.vpc.id
  tags              = var.tags
}

# Private subnet
resource "aws_subnet" "private" {
  for_each          = { for i in [3, 4] : i => cidrsubnet(aws_vpc.vpc.cidr_block, 8, i) }
  cidr_block        = each.value
  availability_zone = data.aws_availability_zones.available_zones.names[tonumber(each.key) - 3]
  vpc_id            = aws_vpc.vpc.id
  tags              = var.tags
}

# Route tables for the public and private subnets
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id
  tags   = var.tags
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id
  tags   = var.tags
}

# Associate the newly created route tables to the subnets
resource "aws_route_table_association" "public" {
  for_each       = aws_subnet.public
  route_table_id = aws_route_table.public.id
  subnet_id      = each.value.id
}

resource "aws_route_table_association" "private" {
  for_each       = aws_subnet.private
  route_table_id = aws_route_table.private.id
  subnet_id      = each.value.id
}

# Internet Gateway allows communication between the VPC and the internet
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags   = var.tags
}

# Elastic IP for internet access
resource "aws_eip" "natgw" {
  vpc                       = true
  associate_with_private_ip = var.eip_private_ip
  depends_on                = [aws_internet_gateway.igw]
  tags                      = var.tags
}

# Public NAT gateway in the public subnet
# The NAT gateway allows resources within the VPC to communicate with the internet but will prevent communication to the VPC from outside sources
resource "aws_nat_gateway" "natgw" {
  allocation_id = aws_eip.natgw.id
  subnet_id     = lookup(aws_subnet.public, 1).id
  depends_on    = [aws_eip.natgw]
  tags          = var.tags
}

# Traffic from private subnets reaches internet via the NAT Gateway (private_subnet--[NAT GW]-->internet)
resource "aws_route" "private_natgw" {
  route_table_id         = aws_route_table.private.id
  nat_gateway_id         = aws_nat_gateway.natgw.id
  destination_cidr_block = "0.0.0.0/0"
}

# Traffic from public subnets reaches internet via the Internet Gateway (public_subnet--[IGW]-->internet)
resource "aws_route" "public_igw" {
  route_table_id         = aws_route_table.public.id
  gateway_id             = aws_internet_gateway.igw.id
  destination_cidr_block = "0.0.0.0/0"
}
