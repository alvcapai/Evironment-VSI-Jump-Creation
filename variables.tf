variable "ibm_region" {
  description = "IBM Cloud region for all resources (e.g., us-south)."
  type        = string
  default     = "us-south"
}

variable "name_prefix" {
  description = "Prefix used to name resources."
  type        = string
  default     = "jump"
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
  description = "CIDR allowed to reach the jump host on RDP/SSH."
  type        = string
  default     = "179.100.99.37/32"
}

variable "ssh_public_key" {
  description = "Public SSH key material used to create the IBM Cloud SSH key for the jump host."
  type        = string
}

variable "windows_image_id" {
  description = "IBM Cloud VPC image ID for the Windows Server image."
  type        = string
}

variable "instance_profile" {
  description = "Instance profile for the jump host."
  type        = string
  default     = "bx2-2x8"
}

variable "jump_volume_size" {
  description = "Boot volume size in GB for the jump host."
  type        = number
  default     = 50
}

variable "transit_gateway_destination_cidr" {
  description = "CIDR routed from the VPC to the transit gateway."
  type        = string
  default     = "172.16.0.0/12"
}

variable "default_tags" {
  description = "Map of tags to apply to all resources."
  type        = list(string)
  default     = []
}
