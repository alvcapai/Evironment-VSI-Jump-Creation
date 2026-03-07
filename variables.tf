variable "ibm_region" {
  description = "IBM Cloud region for all resources (e.g., us-south)."
  type        = string
  default     = "us-south"
}

variable "name_prefix" {
  description = "Prefix used to name resources."
  type        = string
  default     = "linux-jump"
}

variable "resource_group_name" {
  description = "Name of the IBM Cloud resource group to place all resources in (must already exist)."
  type        = string

  validation {
    condition     = length(var.resource_group_name) > 0
    error_message = "resource_group_name must be provided (e.g., Default or your specific RG name)."
  }
}

variable "existing_vpc_name" {
  description = "Name of the existing IBM Cloud VPC to deploy resources into."
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC address prefix."
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet."
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR block for the private subnet."
  type        = string
  default     = "10.0.101.0/24"
}

variable "allowed_admin_cidr" {
  description = "CIDR allowed to reach the jump host on SSH."
  type        = string

  validation {
    condition     = length(var.allowed_admin_cidr) > 0
    error_message = "allowed_admin_cidr must be set to your public IP/CIDR (e.g., 203.0.113.10/32)."
  }
}

variable "ssh_public_key" {
  description = "Public SSH key material used to create the IBM Cloud SSH key for the jump host."
  type        = string
}

variable "linux_image_id" {
  description = "IBM Cloud VPC image ID for the Linux image (e.g., Ubuntu, Debian, RHEL)."
  type        = string

  validation {
    condition = length(var.linux_image_id) > 0 && can(regex("^r[0-9]{3}-[0-9a-f-]+$", var.linux_image_id))
    error_message = "linux_image_id must be set to a valid image *ID* (e.g., r006-…)."
  }
}

variable "instance_profile" {
  description = "Instance profile for the jump host."
  type        = string
  default     = "cx2-2x4"
}

variable "jump_volume_size" {
  description = "Boot volume size in GB for the jump host."
  type        = number
  default     = 40
}

variable "default_tags" {
  description = "Map of tags to apply to all resources."
  type        = list(string)
  default     = []
}
