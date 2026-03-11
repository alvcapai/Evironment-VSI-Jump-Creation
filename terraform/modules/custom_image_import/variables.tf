variable "resource_group_id" {
  description = "Resource group ID for the custom image."
  type        = string
}

variable "custom_image_name" {
  description = "Name for the imported VPC custom image."
  type        = string
}

variable "cos_instance_id" {
  description = "COS instance ID that hosts the QCOW2 object."
  type        = string
}

variable "image_href" {
  description = "COS href for the QCOW2 image (cos://bucket/object)."
  type        = string
}

variable "tags" {
  description = "Tags to apply to the custom image."
  type        = set(string)
  default     = []
}
