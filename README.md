AWS Transit Gateway Setup using Terraform
This Terraform configuration provisions an AWS Transit Gateway (TGW) and connects it to multiple manually created VPCs, as well as an on-premises network via a site-to-site VPN.

📦 Resources Provisioned
🛠 Transit Gateway
Resource: aws_ec2_transit_gateway.tgw

Provisions a centralized Transit Gateway to enable routing between attached VPCs and external networks (e.g., on-premises).

🛠 VPC Attachments
Resource: aws_ec2_transit_gateway_vpc_attachment

Attaches each VPC in var.vpc_ids to the TGW using the corresponding private subnets from var.private_subnets.

🛠 VPN Gateway (VGW)
Resource: aws_vpn_gateway.vpn_gw

Creates a VPN Gateway and attaches it to the first VPC in the list to facilitate the VPN connection.

🛠 Customer Gateway (CGW)
Resource: aws_customer_gateway.cgw

Defines the on-premises customer gateway using the provided IP address, ASN, and connection type.

🛠 VPN Connection
Resource: aws_vpn_connection.vpn_connection

Establishes a site-to-site VPN between the Transit Gateway and the Customer Gateway.

🛠 Transit Gateway Route Table
Resource: aws_ec2_transit_gateway_route_table.tgw_route_table

Manages custom routes for traffic between VPCs and to/from the VPN connection.

🛠 TGW Routes
Automatically creates routes for inter-VPC and VPN traffic using a round-robin routing logic.

🔧 Input Variables

Variable	Description
vpc_ids	List of VPC IDs to be attached to the Transit Gateway
private_subnets	Nested list of private subnet IDs corresponding to each VPC
vpc_cidr_blocks	List of CIDR blocks for each VPC, used for routing
customer_gateway_bgp_asn	BGP ASN for the on-premises Customer Gateway
customer_gateway_ip	Public IP address of the Customer Gateway
vpn_connection_type	Type of VPN connection (typically "ipsec.1")
🔐 Networking Configuration
On the On-Premises Side
Ensure your firewall and routing configuration supports IPsec:

bash
Copy
Edit
# Open necessary ports
sudo iptables -A INPUT -p udp --dport 500 -j ACCEPT
sudo iptables -A INPUT -p udp --dport 4500 -j ACCEPT

# Add route to AWS VPC CIDRs through the VPN tunnel
sudo ip route add <VPC_CIDR> via <Tunnel_Endpoint_IP>
On the AWS Side
Attach the VPN Gateway to the first VPC.

Update Security Groups and Network ACLs to allow:

UDP ports 500 and 4500

Protocol 50 (ESP)

🧭 Routing Notes
Uses round-robin logic for route propagation between VPCs.

You may add static routes in individual VPC route tables pointing to the Transit Gateway for direct inter-VPC communication.

Custom routing logic can be implemented for advanced routing requirements.

✅ Example Terraform Module Usage
hcl
Copy
Edit
module "tgw_setup" {
  source = "./tgw-module"

  vpc_ids                = ["vpc-12345", "vpc-67890"]
  private_subnets        = [["subnet-a1", "subnet-a2"], ["subnet-b1", "subnet-b2"]]
  vpc_cidr_blocks        = ["10.0.0.0/16", "10.1.0.0/16"]
  customer_gateway_bgp_asn = 65001
  customer_gateway_ip    = "203.0.113.1"
  vpn_connection_type    = "ipsec.1"
}
📘 Additional Notes
Ensure all referenced subnet IDs and VPCs already exist.

Consider enabling route propagation in VPC route tables if needed.

CloudWatch logs and tunnel monitoring can be added to improve visibility and reliability.

