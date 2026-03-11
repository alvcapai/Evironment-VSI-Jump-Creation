# Custom Image Import Module

Imports a QCOW2 image from COS into the IBM Cloud VPC Image Catalog.

Resources
- `ibm_iam_authorization_policy` to allow VPC image service access to COS
- `ibm_is_image` referencing the COS object

Inputs
- `custom_image_name`, `image_href`, `cos_instance_id`, `resource_group_id`, `tags`

Outputs
- `image_id`
