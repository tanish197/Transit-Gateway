resource "aws_ec2_transit_gateway" "tgw" {
  description = "My Transit Gateway"
  tags = {
    Name = "MyTransitGateway"
  }
}

# Transit Gateway VPC Attachments for manually created VPCs
resource "aws_ec2_transit_gateway_vpc_attachment" "vpc_attachments" {
  count               = length(var.vpc_ids)
  transit_gateway_id  = aws_ec2_transit_gateway.tgw.id
  vpc_id              = var.vpc_ids[count.index]
  subnet_ids          = concat(
    # var.public_subnets[count.index],   # Replace with existing public subnet IDs
    var.private_subnets[count.index]    # Replace with existing private subnet IDs
  )

  tags = {
    Name = "VPC${count.index + 1}-TGW-Attachment"
  }

  depends_on = [aws_ec2_transit_gateway.tgw]
}

# VPN Gateway (attached to the first VPC)
resource "aws_vpn_gateway" "vpn_gw" {
  vpc_id = var.vpc_ids[0]

  tags = {
    Name = "VPN-Gateway"
  }
}

# Customer Gateway (for the on-premises network)
resource "aws_customer_gateway" "cgw" {
  bgp_asn    = var.customer_gateway_bgp_asn
  ip_address = var.customer_gateway_ip
  type       = var.vpn_connection_type

  tags = {
    Name = "Customer-Gateway"
  }
}

# VPN Connection between the Customer Gateway and the Transit Gateway
resource "aws_vpn_connection" "vpn_connection" {
  customer_gateway_id = aws_customer_gateway.cgw.id
  transit_gateway_id  = aws_ec2_transit_gateway.tgw.id
  type                = var.vpn_connection_type

  tags = {
    Name = "VPN-Connection"
  }
}

# Transit Gateway Route Table for inter-VPC communication
resource "aws_ec2_transit_gateway_route_table" "tgw_route_table" {
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id

  tags = {
    Name = "TGW-Route-Table"
  }
}

# Transit Gateway Routes for inter-VPC communication
resource "aws_ec2_transit_gateway_route" "tgw_routes" {
  count = length(var.vpc_ids)
  destination_cidr_block         = var.vpc_cidr_blocks[(count.index + 1) % length(var.vpc_cidr_blocks)]
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_route_table.id
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.vpc_attachments[(count.index + 1) % length(var.vpc_ids)].id
}
