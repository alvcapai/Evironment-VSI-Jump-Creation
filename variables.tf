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

variable "resource_group" {
  description = "Name of the IBM Cloud resource group to place all resources in (must already exist)."
  type        = string

  validation {
    condition     = length(var.resource_group) > 0
    error_message = "resource_group must be provided (e.g., Default or your specific RG name)."
  }
}

variable "vpc" {
  description = "Name of the existing IBM Cloud VPC to deploy resources into."
  type        = string
}

variable "ssh_key" {
  description = "Name of the existing IBM Cloud SSH key to use for the jump host."
  type        = string

  validation {
    condition     = length(var.ssh_key) > 0
    error_message = "ssh_key must be provided with the target existing SSH key name."
  }
}

variable "image" {
  description = "IBM Cloud VPC image ID (e.g., r006-…)."
  type        = string

  validation {
    condition     = length(var.image) > 0 && can(regex("^r[0-9]{3}-[0-9a-f-]+$", var.image))
    error_message = "image must be set to a valid image *ID* (e.g., r006-…)."
  }
}

variable "machine_profile" {
  description = "Instance profile for the jump host."
  type        = string
  default     = "bx2-4x16"
}

variable "create_floating_ip" {
  description = "Set to true to create a floating IP for the jump host."
  type        = bool
  default     = false
}

