# Terraform: IBM Cloud VPC Jump Host

Creates an IBM Cloud VPC with a Windows jump host, floating IP, and a restrictive security group.

## What it builds
- VPC with public and private subnets (single zone)
- Public gateway attached to the public subnet
- Windows jump host with a floating IP
- Security group allowing **only** `179.100.99.37/32` on ports `3389` and `22`; no egress rules (blocks outbound)
- Transit Gateway integration has been removed.

## Usage
1) Initialize: `terraform init`
2) Plan (supplying your values):  
   `terraform plan -var 'ssh_public_key=<your-ssh-public-key>' -var 'windows_image_id=<windows-image-id>'`
   - To find a valid Windows image **ID** in your region, run:  
     `ibmcloud is images --os windows --visibility public` and copy the ID that starts with `rXXX-`.
3) Apply when ready:  
   `terraform apply -var 'ssh_public_key=<your-ssh-public-key>' -var 'windows_image_id=<windows-image-id>'`

Key inputs (see `variables.tf`):
- `resource_group_name` (required) Existing resource group where all resources will be created
- `ssh_public_key` (required) Public key material; the module creates the IBM Cloud SSH key
- `windows_image_id` (required) Windows Server image ID in your region
- `allowed_admin_cidr` (required) Set to **your** public IP/CIDR (e.g., `203.0.113.10/32`) to allow RDP/SSH
- `ibm_region`, subnet CIDRs, instance profile, boot volume size, and tags (list of strings)

Notes:
- The Windows 2025 image requires a boot volume of **at least 100 GB** (default set accordingly).

Outputs include VPC/subnet IDs, security group ID, instance ID, and floating IP.
