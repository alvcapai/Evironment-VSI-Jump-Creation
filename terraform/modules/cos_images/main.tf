// COS instance and bucket for custom image storage.
resource "ibm_resource_instance" "cos" {
  name              = var.cos_instance_name
  service           = "cloud-object-storage"
  plan              = var.cos_plan
  location          = var.cos_location
  resource_group_id = var.resource_group_id
  tags              = var.tags
}

resource "ibm_cos_bucket" "images" {
  bucket_name          = var.bucket_name
  resource_instance_id = ibm_resource_instance.cos.id
  region_location      = var.region
  storage_class        = var.storage_class
}

locals {
  object_key = var.custom_image_object_key != "" ? var.custom_image_object_key : (
    var.custom_image_file != "" ? basename(var.custom_image_file) : ""
  )
}

// Upload the QCOW2 image when custom image import is enabled.
resource "ibm_cos_bucket_object" "image" {
  count       = var.enable_custom_image ? 1 : 0
  bucket_crn  = ibm_cos_bucket.images.crn
  key         = local.object_key
  content_file = var.custom_image_file
}
