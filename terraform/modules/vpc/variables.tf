variable "create_vpc" {
  description = "When true, create a new VPC. When false, use existing_vpc_name."
  type        = bool
  default     = true
}

variable "existing_vpc_name" {
  description = "Name of an existing VPC when create_vpc is false."
  type        = string
  default     = ""

  validation {
    condition     = var.create_vpc || length(var.existing_vpc_name) > 0
    error_message = "existing_vpc_name is required when create_vpc is false."
  }
}

variable "vpc_name" {
  description = "Name of the VPC when create_vpc is true."
  type        = string
}

variable "subnet_cidr" {
  description = "CIDR block for the subnet."
  type        = string
}

variable "zone" {
  description = "Zone where the subnet is created."
  type        = string
}

variable "allowed_admin_cidr" {
  description = "CIDR allowed to reach the SAP VSI on SSH."
  type        = string
}

variable "resource_group_id" {
  description = "Resource group ID for all VPC resources."
  type        = string
}

variable "tags" {
  description = "Tags to apply to VPC resources."
  type        = set(string)
  default     = []
}
