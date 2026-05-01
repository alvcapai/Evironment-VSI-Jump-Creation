output "vpc_id" {
  description = "ID of the created VPC."
  value       = data.ibm_is_vpc.this.id
}

output "subnet_id" {
  description = "ID of the selected subnet hosting the jump server."
  value       = local.subnet_id
}

output "security_group_id" {
  description = "Security group ID applied to the jump host."
  value       = ibm_is_security_group.jump.id
}

output "ssh_key_id" {
  description = "ID of the existing SSH key used by the jump host."
  value       = data.ibm_is_ssh_key.selected.id
}

output "jump_instance_id" {
  description = "ID of the Linux jump server instance."
  value       = ibm_is_instance.jump.id
}

output "jump_floating_ip" {
  description = "Floating IP assigned to the jump server."
  value       = var.create_floating_ip ? ibm_is_floating_ip.jump[0].address : null
}
