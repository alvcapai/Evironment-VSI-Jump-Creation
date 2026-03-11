variable "instance_name" {
  description = "Name of the SAP VSI."
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where the SAP VSI is deployed."
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID for the SAP VSI primary interface."
  type        = string
}

variable "zone" {
  description = "Zone for the SAP VSI."
  type        = string
}

variable "resource_group_id" {
  description = "Resource group ID for SAP resources."
  type        = string
}

variable "sap_image_regex" {
  description = "Regex used to match the latest SAP-certified SLES image."
  type        = string
}

variable "sap_image_id" {
  description = "Optional explicit image ID to override regex selection."
  type        = string
  default     = ""
}

variable "ssh_key_name" {
  description = "Name of the IBM Cloud SSH key used by the SAP VSI."
  type        = string
}

variable "ssh_public_key" {
  description = "Public key material. If set, a new SSH key is created."
  type        = string
  default     = ""
}

variable "profile" {
  description = "Instance profile for the SAP VSI."
  type        = string
}

variable "boot_volume_size" {
  description = "Boot volume size in GB."
  type        = number
}

variable "security_group_ids" {
  description = "Security groups applied to the SAP VSI network interface."
  type        = list(string)
}

variable "tags" {
  description = "Tags to apply to SAP resources."
  type        = set(string)
  default     = []
}
