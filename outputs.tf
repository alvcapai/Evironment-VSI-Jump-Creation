output "vpc_id" {
  description = "ID of the created VPC."
  value       = data.ibm_is_vpc.this.id
}

output "public_subnet_id" {
  description = "ID of the public subnet hosting the jump server."
  value       = ibm_is_subnet.public.id
}

output "private_subnet_id" {
  description = "ID of the private subnet."
  value       = ibm_is_subnet.private.id
}

output "security_group_id" {
  description = "Security group ID applied to the jump host."
  value       = ibm_is_security_group.jump.id
}

output "ssh_key_id" {
  description = "ID of the SSH key created for the jump host."
  value       = ibm_is_ssh_key.jump.id
}

output "jump_instance_id" {
  description = "ID of the Linux jump server instance."
  value       = ibm_is_instance.jump.id
}

output "jump_floating_ip" {
  description = "Floating IP assigned to the jump server."
  value       = ibm_is_floating_ip.jump.address
}
