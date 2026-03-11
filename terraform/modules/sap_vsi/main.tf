// Discover the latest SAP-certified SLES image by regex.
data "ibm_is_images" "public" {}

locals {
  sap_images = [
    for img in data.ibm_is_images.public.images : img
    if can(regex(var.sap_image_regex, img.name))
  ]

  sap_images_sorted       = sort([for img in local.sap_images : img.created_at])
  sap_latest_created_at   = length(local.sap_images_sorted) > 0 ? local.sap_images_sorted[length(local.sap_images_sorted) - 1] : ""
  sap_latest_image_id     = length(local.sap_images_sorted) > 0 ? element([for img in local.sap_images : img.id if img.created_at == local.sap_latest_created_at], 0) : ""
  selected_image_id       = var.sap_image_id != "" ? var.sap_image_id : local.sap_latest_image_id
}

resource "ibm_is_ssh_key" "sap" {
  count          = var.ssh_public_key != "" ? 1 : 0
  name           = var.ssh_key_name
  public_key     = var.ssh_public_key
  resource_group = var.resource_group_id
  tags           = var.tags
}

data "ibm_is_ssh_key" "existing" {
  count = var.ssh_public_key == "" ? 1 : 0
  name  = var.ssh_key_name
}

locals {
  ssh_key_id = var.ssh_public_key != "" ? ibm_is_ssh_key.sap[0].id : data.ibm_is_ssh_key.existing[0].id
}

resource "ibm_is_instance" "sap" {
  name           = var.instance_name
  image          = local.selected_image_id
  profile        = var.profile
  zone           = var.zone
  vpc            = var.vpc_id
  resource_group = var.resource_group_id

  primary_network_interface {
    subnet          = var.subnet_id
    security_groups = var.security_group_ids
  }

  keys = [local.ssh_key_id]

  boot_volume {
    name    = "${var.instance_name}-boot"
    profile = "general-purpose"
    size    = var.boot_volume_size
  }

  tags = var.tags

  lifecycle {
    precondition {
      condition     = local.selected_image_id != ""
      error_message = "No SAP-certified SLES image matched sap_image_regex, and sap_image_id was not provided."
    }
  }
}

resource "ibm_is_floating_ip" "sap" {
  name           = "${var.instance_name}-fip"
  target         = ibm_is_instance.sap.primary_network_interface[0].id
  resource_group = var.resource_group_id
  tags           = var.tags
}
