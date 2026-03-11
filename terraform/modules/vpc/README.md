# VPC Module

Creates the VPC primitives required for the SAP VSI.

Resources
- `ibm_is_vpc` when `create_vpc` is true
- `ibm_is_subnet` for the SAP workload
- `ibm_is_security_group` with SSH ingress and outbound egress

Inputs
- `create_vpc`, `existing_vpc_name`, `vpc_name`
- `subnet_cidr`, `zone`, `allowed_admin_cidr`
- `resource_group_id`, `tags`

Outputs
- `vpc_id`, `subnet_id`, `security_group_id`
