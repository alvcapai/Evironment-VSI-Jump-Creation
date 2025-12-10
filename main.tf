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

locals {
  tags = merge(
    var.default_tags,
    {
      Project = "jumpserver-transit-gateway"
    }
  )
}

data "ibm_is_zones" "available" {
  region = var.ibm_region
}

locals {
  zone = data.ibm_is_zones.available.zones[0]
}

resource "ibm_is_vpc" "this" {
  name = "${var.name_prefix}-vpc"
  tags = local.tags
}

resource "ibm_is_ssh_key" "jump" {
  name       = "${var.name_prefix}-ssh-key"
  public_key = var.ssh_public_key
  tags       = local.tags
}

resource "ibm_is_public_gateway" "public" {
  name = "${var.name_prefix}-pgw"
  vpc  = ibm_is_vpc.this.id
  zone = local.zone
  tags = local.tags
}

resource "ibm_is_subnet" "public" {
  name                     = "${var.name_prefix}-public"
  vpc                      = ibm_is_vpc.this.id
  zone                     = local.zone
  ipv4_cidr_block          = var.public_subnet_cidr
  public_gateway           = ibm_is_public_gateway.public.id
  total_ipv4_address_count = null
  tags                     = local.tags
}

resource "ibm_is_subnet" "private" {
  name                     = "${var.name_prefix}-private"
  vpc                      = ibm_is_vpc.this.id
  zone                     = local.zone
  ipv4_cidr_block          = var.private_subnet_cidr
  total_ipv4_address_count = null
  tags                     = local.tags
}

resource "ibm_is_security_group" "jump" {
  name = "${var.name_prefix}-jump-sg"
  vpc  = ibm_is_vpc.this.id
  tags = local.tags
}

resource "ibm_is_security_group_rule" "jump_rdp" {
  group     = ibm_is_security_group.jump.id
  direction = "inbound"
  remote    = var.allowed_admin_cidr
  tcp {
    port_min = 3389
    port_max = 3389
  }
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
  image   = var.windows_image_id
  profile = var.instance_profile
  zone    = local.zone
  vpc     = ibm_is_vpc.this.id

  primary_network_interface {
    subnet          = ibm_is_subnet.public.id
    security_groups = [ibm_is_security_group.jump.id]
  }

  keys = [ibm_is_ssh_key.jump.id]

  boot_volume {
    name                             = "${var.name_prefix}-jump-boot"
    profile                          = "general-purpose"
    size                             = var.jump_volume_size
    delete_volume_on_instance_delete = true
    tags                             = local.tags
  }

  tags = local.tags
}

resource "ibm_is_floating_ip" "jump" {
  name   = "${var.name_prefix}-jump-fip"
  zone   = local.zone
  target = ibm_is_instance.jump.primary_network_interface[0].id
  tags   = local.tags
}

resource "ibm_tg_gateway" "this" {
  name     = "${var.name_prefix}-tgw"
  location = var.ibm_region
  global   = false
  tags     = local.tags
}

resource "ibm_tg_connection" "vpc" {
  gateway        = ibm_tg_gateway.this.id
  network_type   = "vpc"
  name           = "${var.name_prefix}-tgw-vpc"
  network_id     = ibm_is_vpc.this.id
  base_connection = true
  tags           = local.tags
}

resource "ibm_is_vpc_routing_table_route" "tgw_route" {
  vpc           = ibm_is_vpc.this.id
  routing_table = ibm_is_vpc.this.default_routing_table
  name          = "${var.name_prefix}-to-tgw"
  destination   = var.transit_gateway_destination_cidr
  action        = "delegate"
  next_hop      = ibm_tg_connection.vpc.id
}
