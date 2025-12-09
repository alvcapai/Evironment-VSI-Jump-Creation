terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

locals {
  tags = merge(
    var.default_tags,
    {
      Project = "jumpserver-transit-gateway"
    }
  )
}

data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_ami" "windows" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["Windows_Server-2022-English-Full-Base-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(local.tags, { Name = "${var.name_prefix}-vpc" })
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = merge(local.tags, { Name = "${var.name_prefix}-igw" })
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = merge(local.tags, { Name = "${var.name_prefix}-public" })
}

resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.private_subnet_cidr
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = merge(local.tags, { Name = "${var.name_prefix}-private" })
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = merge(local.tags, { Name = "${var.name_prefix}-public-rt" })
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id

  # Route to remote networks via the transit gateway.
  route {
    cidr_block         = var.transit_gateway_destination_cidr
    transit_gateway_id = aws_ec2_transit_gateway.this.id
  }

  tags = merge(local.tags, { Name = "${var.name_prefix}-private-rt" })
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}

resource "aws_security_group" "jump" {
  name        = "${var.name_prefix}-jump-sg"
  description = "Access to the Windows jump server"
  vpc_id      = aws_vpc.this.id

  ingress {
    description = "RDP from allowed CIDR"
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = [var.allowed_rdp_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.tags, { Name = "${var.name_prefix}-jump-sg" })
}

resource "aws_instance" "jump" {
  ami                         = data.aws_ami.windows.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.jump.id]
  associate_public_ip_address = true
  key_name                    = var.key_name

  # Keep storage and networking simple for a bastion-style jump host.
  root_block_device {
    volume_size = var.jump_volume_size
    volume_type = "gp3"
  }

  tags = merge(local.tags, { Name = "${var.name_prefix}-jump" })
}

resource "aws_ec2_transit_gateway" "this" {
  description = "${var.name_prefix}-tgw"

  tags = merge(local.tags, { Name = "${var.name_prefix}-tgw" })
}

resource "aws_ec2_transit_gateway_vpc_attachment" "this" {
  transit_gateway_id = aws_ec2_transit_gateway.this.id
  vpc_id             = aws_vpc.this.id
  subnet_ids         = [aws_subnet.private.id]

  tags = merge(local.tags, { Name = "${var.name_prefix}-tgw-attachment" })
}
