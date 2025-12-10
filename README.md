# Terraform: IBM Cloud VPC Jump Host with Transit Gateway

Creates an IBM Cloud VPC with a Windows jump host, floating IP, restrictive security group, and a Transit Gateway connection.

## What it builds
- VPC with public and private subnets (single zone)
- Public gateway attached to the public subnet
- Windows jump host with a floating IP
- Security group allowing **only** `179.100.99.37/32` on ports `3389` and `22`; no egress rules (blocks outbound)
- Transit Gateway and VPC connection, plus a route delegating a destination CIDR to the TGW

## Usage
1) Initialize: `terraform init`
2) Plan (supplying your values):  
   `terraform plan -var 'ssh_public_key=<your-ssh-public-key>' -var 'windows_image_id=<windows-image-uuid>'`
3) Apply when ready:  
   `terraform apply -var 'ssh_public_key=<your-ssh-public-key>' -var 'windows_image_id=<windows-image-uuid>'`

Key inputs (see `variables.tf`):
- `ssh_public_key` (required) Public key material; the module creates the IBM Cloud SSH key
- `windows_image_id` (required) Windows Server image ID in your region
- `allowed_admin_cidr` defaults to `179.100.99.37/32`; change if your admin IP changes
- `transit_gateway_destination_cidr` network routed through the TGW
- `ibm_region`, subnet CIDRs, instance profile, boot volume size, and tags

Outputs include VPC/subnet IDs, security group ID, instance ID, floating IP, transit gateway ID, and the TGW connection/route IDs.
