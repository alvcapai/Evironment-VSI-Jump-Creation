# SAP VSI Module

Creates a SUSE Linux for SAP VPC instance, floating IP, and SSH key wiring.

Resources
- `ibm_is_instance` for the SAP VSI
- `ibm_is_floating_ip` for inbound access
- `ibm_is_ssh_key` when `ssh_public_key` is provided

Image Selection
- Uses `sap_image_regex` to select the latest SAP-certified SLES image.
- Set `sap_image_id` to override automatic selection.

Inputs
- `instance_name`, `profile`, `boot_volume_size`
- `vpc_id`, `subnet_id`, `zone`, `resource_group_id`
- `sap_image_regex`, optional `sap_image_id`
- `ssh_key_name`, optional `ssh_public_key`
- `security_group_ids`, `tags`

Outputs
- `instance_id`, `floating_ip`, `ssh_key_id`, `image_id`
