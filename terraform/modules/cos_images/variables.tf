variable "resource_group_id" {
  description = "Resource group ID for COS resources."
  type        = string
}

variable "region" {
  description = "IBM Cloud region used for the COS bucket location."
  type        = string
}

variable "cos_instance_name" {
  description = "Name of the COS instance."
  type        = string
}

variable "cos_plan" {
  description = "COS plan for the instance."
  type        = string
}

variable "cos_location" {
  description = "COS instance location (global or regional)."
  type        = string
}

variable "bucket_name" {
  description = "COS bucket name for custom images."
  type        = string
}

variable "enable_custom_image" {
  description = "When true, upload the QCOW2 image to COS."
  type        = bool
  default     = false
}

variable "custom_image_file" {
  description = "Local path to the QCOW2 file."
  type        = string
  default     = ""
}

variable "custom_image_object_key" {
  description = "Optional COS object key for the QCOW2 file."
  type        = string
  default     = ""
}

variable "storage_class" {
  description = "Storage class for the COS bucket."
  type        = string
  default     = "standard"
}

variable "tags" {
  description = "Tags to apply to COS resources."
  type        = set(string)
  default     = []
}
