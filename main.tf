terraform {
  required_version = ">= 1.5.0"

  required_providers {
    ibm = {
      source  = "IBM-Cloud/ibm"
      version = ">= 1.61.0"
    }
  }
}

provider "ibm" {
  region = var.ibm_region
}

data "ibm_resource_group" "rg" {
  name = var.resource_group_name
}

data "ibm_is_vpc" "this" {
  name = "vpc-alvaro"
}

locals {
  tags = toset(concat(var.default_tags, ["Project:linux-jumpserver-migration"]))
}

resource "ibm_is_ssh_key" "jump" {
  name       = "${var.name_prefix}-ssh-key"
  public_key = var.ssh_public_key
  resource_group = data.ibm_resource_group.rg.id
  tags       = local.tags
}

resource "ibm_is_public_gateway" "public" {
  name = "${var.name_prefix}-pgw"
  vpc  = data.ibm_is_vpc.this.id
  zone = local.zone
  resource_group = data.ibm_resource_group.rg.id
  tags = local.tags
}

# Removido address prefix pois vamos usar a VPC existente

resource "ibm_is_subnet" "public" {
  name                     = "${var.name_prefix}-public"
  vpc                      = data.ibm_is_vpc.this.id
  zone                     = local.zone
  ipv4_cidr_block          = var.public_subnet_cidr
  public_gateway           = ibm_is_public_gateway.public.id
  total_ipv4_address_count = null
  resource_group           = data.ibm_resource_group.rg.id
  tags                     = local.tags
}

resource "ibm_is_subnet" "private" {
  name                     = "${var.name_prefix}-private"
  vpc                      = data.ibm_is_vpc.this.id
  zone                     = local.zone
  ipv4_cidr_block          = var.private_subnet_cidr
  total_ipv4_address_count = null
  resource_group           = data.ibm_resource_group.rg.id
  tags                     = local.tags
}

resource "ibm_is_security_group" "jump" {
  name = "${var.name_prefix}-jump-sg"
  vpc  = data.ibm_is_vpc.this.id
  resource_group = data.ibm_resource_group.rg.id
  tags = local.tags
}

resource "ibm_is_security_group_rule" "jump_ssh" {
  group     = ibm_is_security_group.jump.id
  direction = "inbound"
  remote    = var.allowed_admin_cidr
  tcp {
    port_min = 22
    port_max = 22
  }
}

# No outbound rules defined to block all egress traffic.

resource "ibm_is_instance" "jump" {
  name    = "${var.name_prefix}-jump"
  image   = var.linux_image_id
  profile = var.instance_profile
  zone    = local.zone
  vpc     = data.ibm_is_vpc.this.id
  resource_group = data.ibm_resource_group.rg.id

  primary_network_interface {
    subnet          = ibm_is_subnet.public.id
    security_groups = [ibm_is_security_group.jump.id]
  }

  keys = [ibm_is_ssh_key.jump.id]

  boot_volume {
    name                             = "${var.name_prefix}-jump-boot"
    profile                          = "general-purpose"
    size                             = var.jump_volume_size
  }

  tags = local.tags
}

resource "ibm_is_floating_ip" "jump" {
  name   = "${var.name_prefix}-jump-fip"
  target = ibm_is_instance.jump.primary_network_interface[0].id
  resource_group = data.ibm_resource_group.rg.id
  tags   = local.tags
}
