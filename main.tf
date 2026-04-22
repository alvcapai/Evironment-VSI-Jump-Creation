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

data "ibm_is_subnet" "selected" {
  name = var.existing_subnet_name
}

locals {
  zone = data.ibm_is_subnet.selected.zone
  tags = toset(concat(var.default_tags, ["Project:linux-jumpserver-migration"]))
}

data "ibm_is_ssh_key" "selected" {
  name           = var.existing_ssh_key_name
  resource_group = data.ibm_resource_group.rg.id
}


resource "ibm_is_security_group" "jump" {
  name           = "${var.name_prefix}-jump-sg"
  vpc            = data.ibm_is_vpc.this.id
  resource_group = data.ibm_resource_group.rg.id
  tags           = local.tags
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
  name           = "${var.name_prefix}-jump"
  image          = var.linux_image_id
  profile        = var.instance_profile
  zone           = local.zone
  vpc            = data.ibm_is_vpc.this.id
  resource_group = data.ibm_resource_group.rg.id

  primary_network_interface {
    subnet          = data.ibm_is_subnet.selected.id
    security_groups = [ibm_is_security_group.jump.id]
  }

  keys = [data.ibm_is_ssh_key.selected.id]

  boot_volume {
    name    = "${var.name_prefix}-jump-boot"
    profile = "general-purpose"
    size    = var.jump_volume_size
  }

  tags = local.tags
}

resource "ibm_is_floating_ip" "jump" {
  name           = "${var.name_prefix}-jump-fip"
  target         = ibm_is_instance.jump.primary_network_interface[0].id
  resource_group = data.ibm_resource_group.rg.id
  tags           = local.tags
}
