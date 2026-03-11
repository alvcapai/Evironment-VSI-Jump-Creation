// VPC and subnet module for SAP workloads.
resource "ibm_is_vpc" "this" {
  count                     = var.create_vpc ? 1 : 0
  name                      = var.vpc_name
  resource_group            = var.resource_group_id
  address_prefix_management = "auto"
  tags                      = var.tags
}

data "ibm_is_vpc" "existing" {
  count = var.create_vpc ? 0 : 1
  name  = var.existing_vpc_name
}

locals {
  vpc_id = var.create_vpc ? ibm_is_vpc.this[0].id : data.ibm_is_vpc.existing[0].id
}

resource "ibm_is_subnet" "this" {
  name            = "${var.vpc_name}-sap-subnet"
  vpc             = local.vpc_id
  zone            = var.zone
  ipv4_cidr_block = var.subnet_cidr
  resource_group  = var.resource_group_id
  tags            = var.tags
}

resource "ibm_is_security_group" "sap" {
  name           = "${var.vpc_name}-sap-sg"
  vpc            = local.vpc_id
  resource_group = var.resource_group_id
  tags           = var.tags
}

// Allow SSH from the admin CIDR to manage the SAP VSI.
resource "ibm_is_security_group_rule" "ssh_inbound" {
  group     = ibm_is_security_group.sap.id
  direction = "inbound"
  remote    = var.allowed_admin_cidr
  protocol  = "tcp"
  port_min  = 22
  port_max  = 22
}

// Allow all outbound traffic for OS updates and tooling.
resource "ibm_is_security_group_rule" "egress_all" {
  group     = ibm_is_security_group.sap.id
  direction = "outbound"
  remote    = "0.0.0.0/0"
}
