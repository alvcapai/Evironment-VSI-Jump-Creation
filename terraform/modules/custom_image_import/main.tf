// Allow the VPC image service to read from COS during image import.
resource "ibm_iam_authorization_policy" "is_to_cos" {
  source_service_name = "is"
  target_service_name = "cloud-object-storage"
  target_resource_instance_id = var.cos_instance_id
  roles               = ["Reader"]
}

resource "ibm_is_image" "custom" {
  name           = var.custom_image_name
  href           = var.image_href
  resource_group = var.resource_group_id
  tags           = var.tags

  depends_on = [ibm_iam_authorization_policy.is_to_cos]
}
