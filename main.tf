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

variable "windows_image_id" {
  description = "Legacy variable to satisfy Schematics. Not used."
  type        = string
  default     = "r006-00000000-0000-0000-0000-000000000000"
}

data "ibm_resource_group" "rg" {
  name = var.resource_group_name
}

data "ibm_is_vpc" "this" {
  name = var.existing_vpc_name
}

data "ibm_is_zones" "available" {
  region = var.ibm_region
}

locals {
  zone = data.ibm_is_zones.available.zones[0]
  tags = toset(concat(var.default_tags, ["Project:linux-jumpserver-migration"]))
}

resource "ibm_is_ssh_key" "jump" {
  name       = "${var.name_prefix}-ssh-key"
  public_key = var.ssh_public_key
  resource_group = data.ibm_resource_group.rg.id
  tags       = local.tags
}

# Usar Public Gateway existente
data "ibm_is_public_gateway" "public" {
  name = "${var.name_prefix}-pgw"
}

# Usar Subnets existentes
data "ibm_is_subnet" "public" {
  name = "${var.name_prefix}-public"
}

data "ibm_is_subnet" "private" {
  name = "${var.name_prefix}-private"
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
  protocol  = "tcp"
  port_min  = 22
  port_max  = 22
}

resource "ibm_is_security_group_rule" "jump_egress_all" {
  group     = ibm_is_security_group.jump.id
  direction = "outbound"
  remote    = "0.0.0.0/0"
}

resource "ibm_is_instance" "jump" {
  name    = "${var.name_prefix}-jump"
  image   = var.linux_image_id
  profile = var.instance_profile
  zone    = local.zone
  vpc     = data.ibm_is_vpc.this.id
  resource_group = data.ibm_resource_group.rg.id

  primary_network_interface {
    subnet          = data.ibm_is_subnet.public.id
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
