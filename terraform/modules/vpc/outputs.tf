output "vpc_id" {
  description = "ID of the VPC used for the SAP VSI."
  value       = local.vpc_id
}

output "subnet_id" {
  description = "ID of the subnet created for the SAP VSI."
  value       = ibm_is_subnet.this.id
}

output "security_group_id" {
  description = "Security group ID applied to the SAP VSI."
  value       = ibm_is_security_group.sap.id
}
