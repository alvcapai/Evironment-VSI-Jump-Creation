output "vpc_id" {
  description = "ID of the VPC hosting the SAP VSI."
  value       = module.vpc.vpc_id
}

output "subnet_id" {
  description = "ID of the subnet hosting the SAP VSI."
  value       = module.vpc.subnet_id
}

output "security_group_id" {
  description = "Security group ID applied to the SAP VSI."
  value       = module.vpc.security_group_id
}

output "sap_instance_id" {
  description = "ID of the SUSE Linux for SAP VSI."
  value       = module.sap_vsi.instance_id
}

output "sap_floating_ip" {
  description = "Floating IP assigned to the SAP VSI."
  value       = module.sap_vsi.floating_ip
}

output "sap_image_id" {
  description = "ID of the SAP-certified SLES image selected by regex."
  value       = module.sap_vsi.image_id
}

output "cos_bucket_name" {
  description = "Name of the COS bucket used for image storage."
  value       = module.cos_images.bucket_name
}

output "cos_object_key" {
  description = "Object key of the uploaded QCOW2 image, if enabled."
  value       = module.cos_images.object_key
}

output "custom_image_href" {
  description = "COS href used for importing the custom image, if enabled."
  value       = module.cos_images.image_href
}

output "custom_image_id" {
  description = "ID of the imported custom VPC image, if enabled."
  value       = try(module.custom_image_import[0].image_id, null)
}
