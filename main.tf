terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = merge(var.tags, {
    Name = "${var.name}"
  })
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  tags = merge(var.tags, { Name = "${var.name}-igw" })
}

resource "aws_subnet" "public" {
  count                   = length(var.public_subnets)
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnets[count.index]
  map_public_ip_on_launch = true
  availability_zone       = element(var.azs, count.index)
  tags = merge(var.tags, {
    Name = "${var.name}-public-${count.index + 1}"
  })
}

resource "aws_subnet" "private_app" {
  count             = length(var.private_subnets)
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.app_subnets[count.index]
  availability_zone = element(var.azs, count.index)
  tags = merge(var.tags, {
    Name = "${var.name}-app-${count.index + 1}"
  })
}

resource "aws_subnet" "private_data" {
  count             = length(var.private_subnets)
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.data_subnets[count.index]
  availability_zone = element(var.azs, count.index)
  tags = merge(var.tags, {
    Name = "${var.name}-data-${count.index + 1}"
  })
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id
  tags   = merge(var.tags, { Name = "${var.name}-public-rt" })
}

resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id              = aws_internet_gateway.this.id
}

resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

##########################
# NAT Type Selection
##########################

# Option 1: AWS Managed NAT Gateway
resource "aws_eip" "nat" {
  count = var.nat_type == "nat-gateway" ? 1 : 0
  tags  = merge(var.tags, { Name = "${var.name}-nat-eip" })
}

resource "aws_nat_gateway" "this" {
  count         = var.nat_type == "nat-gateway" ? 1 : 0
  allocation_id = aws_eip.nat[0].id
  subnet_id     = element(aws_subnet.public[*].id, 0)
  tags          = merge(var.tags, { Name = "${var.name}-nat-gateway" })
}

# Option 2: FCK-NAT instance
resource "aws_instance" "fck_nat" {
  count                       = var.nat_type == "fck-nat" ? 1 : 0
  ami                         = var.fck_nat_ami
  instance_type               = var.fck_nat_instance_type
  subnet_id                   = element(aws_subnet.public[*].id, 0)
  associate_public_ip_address = true
  source_dest_check           = false
  tags                        = merge(var.tags, { Name = "${var.name}-fck-nat" })
}

##########################
# Private Route Table
##########################

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id
  tags   = merge(var.tags, { Name = "${var.name}-private-rt" })
}

resource "aws_route" "private_nat" {
  count = var.nat_type == "nat-gateway" ? 1 : var.nat_type == "fck-nat" ? 1 : 0
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = var.nat_type == "nat-gateway" ? aws_nat_gateway.this[0].id : null
  #instance_id            = var.nat_type == "fck-nat" ? aws_instance.fck_nat[0].id : null
}

resource "aws_route_table_association" "private" {
  count          = length(aws_subnet.private)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}
