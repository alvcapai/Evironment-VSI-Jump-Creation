output "cos_instance_id" {
  description = "ID of the COS instance."
  value       = ibm_resource_instance.cos.id
}

output "bucket_name" {
  description = "Name of the COS bucket for images."
  value       = ibm_cos_bucket.images.bucket_name
}

output "bucket_crn" {
  description = "CRN of the COS bucket."
  value       = ibm_cos_bucket.images.crn
}

output "object_key" {
  description = "Object key of the QCOW2 image when uploaded."
  value       = try(ibm_cos_bucket_object.image[0].key, null)
}

output "image_href" {
  description = "COS href used for VPC custom image import."
  value       = try("cos://${ibm_cos_bucket.images.bucket_name}/${ibm_cos_bucket_object.image[0].key}", null)
}
