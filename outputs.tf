output "vpc_id" {
  description = "ID of the created VPC."
  value       = aws_vpc.this.id
}

output "public_subnet_id" {
  description = "ID of the public subnet hosting the jump server."
  value       = aws_subnet.public.id
}

output "private_subnet_id" {
  description = "ID of the private subnet attached to the transit gateway."
  value       = aws_subnet.private.id
}

output "jump_instance_id" {
  description = "ID of the Windows jump server instance."
  value       = aws_instance.jump.id
}

output "jump_public_ip" {
  description = "Public IP address of the Windows jump server."
  value       = aws_instance.jump.public_ip
}

output "transit_gateway_id" {
  description = "ID of the transit gateway."
  value       = aws_ec2_transit_gateway.this.id
}

output "transit_gateway_vpc_attachment_id" {
  description = "ID of the VPC attachment to the transit gateway."
  value       = aws_ec2_transit_gateway_vpc_attachment.this.id
}

output "private_route_table_id" {
  description = "ID of the private route table that routes to the transit gateway."
  value       = aws_route_table.private.id
}
