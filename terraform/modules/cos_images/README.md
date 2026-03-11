# COS Images Module

Creates an IBM Cloud Object Storage instance and bucket, then optionally uploads a QCOW2 image.

Resources
- `ibm_resource_instance` for COS
- `ibm_cos_bucket` for image storage
- `ibm_cos_bucket_object` for the QCOW2 upload when enabled

Inputs
- `cos_instance_name`, `cos_plan`, `cos_location`
- `bucket_name`, `region`, `storage_class`
- `enable_custom_image`, `custom_image_file`, `custom_image_object_key`
- `resource_group_id`, `tags`

Outputs
- `cos_instance_id`, `bucket_name`, `bucket_crn`, `object_key`, `image_href`
