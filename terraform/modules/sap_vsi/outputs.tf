output "instance_id" {
  description = "ID of the SAP VSI."
  value       = ibm_is_instance.sap.id
}

output "floating_ip" {
  description = "Floating IP address for the SAP VSI."
  value       = ibm_is_floating_ip.sap.address
}

output "ssh_key_id" {
  description = "ID of the SSH key used by the SAP VSI."
  value       = local.ssh_key_id
}

output "image_id" {
  description = "ID of the SAP-certified SLES image selected for the SAP VSI."
  value       = local.selected_image_id
}
