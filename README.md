# Terraform: VPC with Windows Jump Server and Transit Gateway

Creates a minimal AWS environment with a VPC, public jump host, private subnet, and a transit gateway attachment.

## What it builds
- VPC with public and private subnets (single AZ)
- Internet gateway with public routing
- Windows Server 2022 jump host with RDP access
- Transit Gateway and VPC attachment using the private subnet
- Private route to a configurable CIDR via the TGW

## Usage
1) Initialize: `terraform init`
2) Plan: `terraform plan -var 'key_name=your-keypair'`
3) Apply: `terraform apply -var 'key_name=your-keypair'`

Key inputs (see `variables.tf`):
- `key_name` (required) EC2 key pair name to decrypt the Windows password
- `aws_region` (default `us-east-1`)
- `allowed_rdp_cidr` (default `0.0.0.0/0`) tighten to your IP/CIDR
- `transit_gateway_destination_cidr` network you want routed through the TGW
- CIDRs for VPC/public/private subnets

Outputs include the VPC ID, subnet IDs, transit gateway and attachment IDs, and the jump server public IP.
