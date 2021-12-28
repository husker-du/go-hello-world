terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 1.1.0"
}

# This block will grab availability zones that are available to your account.
data "aws_availability_zones" "available_zones" {
  state = "available"
}

# Virtual network isolated from other virtual networks in the AWS Cloud
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr # Range of IPv4 addresses in the VPC
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags                 = var.config.tags
}

# Public subnet (exposed to the internet)
resource "aws_subnet" "public" {
  for_each          = { for i in [1, 2] : i => cidrsubnet(aws_vpc.vpc.cidr_block, var.subnet_newbits, i) }
  cidr_block        = each.value
  availability_zone = data.aws_availability_zones.available_zones.names[tonumber(each.key) - 1]
  vpc_id            = aws_vpc.vpc.id
  tags              = var.config.tags
}

# Private subnet (not directly exposed to the internet)
resource "aws_subnet" "private" {
  for_each          = { for i in [3, 4] : i => cidrsubnet(aws_vpc.vpc.cidr_block, var.subnet_newbits, i) }
  cidr_block        = each.value
  availability_zone = data.aws_availability_zones.available_zones.names[tonumber(each.key) - 3]
  vpc_id            = aws_vpc.vpc.id
  tags              = var.config.tags
}

# Route table associated to the public subnet
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id
  tags   = var.config.tags
}

resource "aws_route_table_association" "public" {
  for_each       = aws_subnet.public
  route_table_id = aws_route_table.public.id
  subnet_id      = each.value.id
}

# Route table associated to the private subnet
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id
  tags   = var.config.tags
}

resource "aws_route_table_association" "private" {
  for_each       = aws_subnet.private
  route_table_id = aws_route_table.private.id
  subnet_id      = each.value.id
}

# Internet Gateway allows communication between the VPC and the internet
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags   = var.config.tags
}

# Elastic IP for internet access via the public NAT
resource "aws_eip" "nat_gw" {
  vpc                       = true
  associate_with_private_ip = var.eip_private_ip
  tags                      = var.config.tags
  depends_on                = [aws_internet_gateway.igw]
}

# Public NAT gateway in the public subnet
# The NAT gateway allows resources within the VPC to communicate with the internet
# but will prevent communication to the VPC from outside sources
resource "aws_nat_gateway" "nat_gw" {
  allocation_id     = aws_eip.nat_gw.id
  subnet_id         = lookup(aws_subnet.public, 1).id
  connectivity_type = "public"
  tags              = var.config.tags
  depends_on        = [aws_eip.nat_gw]
}

# Traffic from private subnets reaches internet via the NAT Gateway (private_subnet--[NAT GW]-->internet)
resource "aws_route" "private_to_inet" {
  route_table_id         = aws_route_table.private.id
  nat_gateway_id         = aws_nat_gateway.nat_gw.id
  destination_cidr_block = "0.0.0.0/0"
}

# Traffic from public subnets reaches internet via the Internet Gateway (public_subnet--[IGW]-->internet)
resource "aws_route" "public_to_inet" {
  route_table_id         = aws_route_table.public.id
  gateway_id             = aws_internet_gateway.igw.id
  destination_cidr_block = "0.0.0.0/0"
}
