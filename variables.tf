variable "aws_region" {
  description = "AWS region where resources will be created."
  type        = string
  default     = "us-east-1"
}

variable "name_prefix" {
  description = "Prefix used to name resources."
  type        = string
  default     = "jump"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet."
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR block for the private subnet used for the transit gateway attachment."
  type        = string
  default     = "10.0.101.0/24"
}

variable "allowed_rdp_cidr" {
  description = "CIDR block allowed to access RDP on the jump server."
  type        = string
  default     = "0.0.0.0/0"
}

variable "key_name" {
  description = "Existing EC2 key pair name to decrypt the Windows Administrator password."
  type        = string
}

variable "instance_type" {
  description = "Instance type for the Windows jump server."
  type        = string
  default     = "t3a.medium"
}

variable "jump_volume_size" {
  description = "Root volume size (GiB) for the jump server."
  type        = number
  default     = 50
}

variable "transit_gateway_destination_cidr" {
  description = "CIDR routed from the VPC to the transit gateway (e.g., on-prem or another VPC)."
  type        = string
  default     = "172.16.0.0/12"
}

variable "default_tags" {
  description = "Map of tags to apply to all resources."
  type        = map(string)
  default     = {}
}
