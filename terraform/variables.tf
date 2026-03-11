variable "ibmcloud_api_key" {
  description = "IBM Cloud API key used by the provider."
  type        = string
  sensitive   = true

  validation {
    condition     = length(var.ibmcloud_api_key) > 0
    error_message = "ibmcloud_api_key must be provided."
  }
}

variable "region" {
  description = "IBM Cloud region for all resources (for example, us-south)."
  type        = string

  validation {
    condition     = length(var.region) > 0
    error_message = "region must be provided."
  }
}

variable "zone" {
  description = "IBM Cloud VPC zone for zonal resources (for example, us-south-1)."
  type        = string

  validation {
    condition     = length(var.zone) > 0
    error_message = "zone must be provided."
  }
}

variable "resource_group" {
  description = "Name of the IBM Cloud resource group to place all resources in."
  type        = string

  validation {
    condition     = length(var.resource_group) > 0
    error_message = "resource_group must be provided."
  }
}

variable "create_vpc" {
  description = "When true, create a new VPC. When false, use existing_vpc_name."
  type        = bool
  default     = true
}

variable "existing_vpc_name" {
  description = "Name of an existing VPC to deploy into when create_vpc is false."
  type        = string
  default     = ""

  validation {
    condition     = var.create_vpc || length(var.existing_vpc_name) > 0
    error_message = "existing_vpc_name is required when create_vpc is false."
  }
}

variable "vpc_name" {
  description = "Name for the VPC when create_vpc is true."
  type        = string
  default     = "rackware-vpc"
}

variable "subnet_cidr" {
  description = "CIDR block for the subnet hosting the SAP VSI."
  type        = string
  default     = "10.50.10.0/24"
}

variable "allowed_admin_cidr" {
  description = "CIDR allowed to reach the SAP VSI on SSH."
  type        = string
  default     = ""

  validation {
    condition     = length(var.allowed_admin_cidr) > 0
    error_message = "allowed_admin_cidr must be set to your public IP/CIDR (for example, 203.0.113.10/32)."
  }
}

variable "ssh_key_name" {
  description = "Name for the IBM Cloud SSH key used by the SAP VSI."
  type        = string

  validation {
    condition     = length(var.ssh_key_name) > 0
    error_message = "ssh_key_name must be provided."
  }
}

variable "ssh_public_key" {
  description = "Public SSH key material to create a new IBM Cloud SSH key. Leave empty to use an existing key by name."
  type        = string
  default     = ""
}

variable "sap_image_regex" {
  description = "Regex used to select the latest SAP-certified SLES image."
  type        = string

  validation {
    condition     = length(var.sap_image_regex) > 0
    error_message = "sap_image_regex must be provided."
  }
}

variable "sap_instance_name" {
  description = "Name for the SAP VSI."
  type        = string
  default     = "sap-vsi"
}

variable "sap_profile" {
  description = "Instance profile for the SAP VSI."
  type        = string
  default     = "bx2-4x16"
}

variable "sap_boot_volume_size" {
  description = "Boot volume size in GB for the SAP VSI."
  type        = number
  default     = 100
}

variable "cos_instance_name" {
  description = "Name of the COS instance used to store images."
  type        = string
  default     = "rackware-cos"
}

variable "cos_plan" {
  description = "COS plan for the instance."
  type        = string
  default     = "standard"
}

variable "cos_location" {
  description = "COS instance location (global or regional)."
  type        = string
  default     = "global"
}

variable "cos_bucket_name" {
  description = "Name of the COS bucket for custom images."
  type        = string

  validation {
    condition     = length(var.cos_bucket_name) > 0
    error_message = "cos_bucket_name must be provided."
  }
}

variable "enable_custom_image" {
  description = "When true, upload a QCOW2 image to COS and import it into the VPC image catalog."
  type        = bool
  default     = false
}

variable "custom_image_file" {
  description = "Local path to the QCOW2 image to upload to COS. Required when enable_custom_image is true."
  type        = string
  default     = ""

  validation {
    condition     = !var.enable_custom_image || length(var.custom_image_file) > 0
    error_message = "custom_image_file must be provided when enable_custom_image is true."
  }
}

variable "custom_image_object_key" {
  description = "Optional COS object key for the QCOW2 file. Defaults to the base filename."
  type        = string
  default     = ""
}

variable "custom_image_name" {
  description = "Name for the imported VPC custom image. Required when enable_custom_image is true."
  type        = string
  default     = ""

  validation {
    condition     = !var.enable_custom_image || length(var.custom_image_name) > 0
    error_message = "custom_image_name must be provided when enable_custom_image is true."
  }
}

variable "default_tags" {
  description = "Tags to apply to all resources."
  type        = list(string)
  default     = []
}
