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
  name = var.resource_group
}

data "ibm_is_vpc" "this" {
  name = var.vpc
}

locals {
  subnet_id = data.ibm_is_vpc.this.subnets[0].id
  zone      = data.ibm_is_vpc.this.subnets[0].zone
  tags      = ["Project:linux-jumpserver-migration"]
}

data "ibm_is_ssh_key" "selected" {
  name           = var.ssh_key
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
  remote    = "0.0.0.0/0"
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
  image          = var.image
  profile        = var.machine_profile
  zone           = local.zone
  vpc            = data.ibm_is_vpc.this.id
  resource_group = data.ibm_resource_group.rg.id
  user_data      = file("${path.module}/init.sh")

  primary_network_interface {
    subnet          = local.subnet_id
    security_groups = [ibm_is_security_group.jump.id]
  }

  keys = [data.ibm_is_ssh_key.selected.id]

  boot_volume {
    name    = "${var.name_prefix}-jump-boot"
    profile = "sdp"
    size    = 1000
    iops    = 3000
  }

  tags = local.tags
}

resource "ibm_is_floating_ip" "jump" {
  count          = var.create_floating_ip ? 1 : 0
  name           = "${var.name_prefix}-jump-fip"
  target         = ibm_is_instance.jump.primary_network_interface[0].id
  resource_group = data.ibm_resource_group.rg.id
  tags           = local.tags
}
