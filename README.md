AWS Transit Gateway Setup using Terraform
This Terraform configuration provisions an AWS Transit Gateway (TGW) and connects it to multiple manually created VPCs. It also establishes a site-to-site VPN connection to an on-premises network through a VPN Gateway and Customer Gateway.

🛠 Resources Created
1. Transit Gateway
Creates a centralized AWS Transit Gateway (aws_ec2_transit_gateway.tgw) to enable routing between attached VPCs and on-premises networks.

2. VPC Attachments
For each VPC in var.vpc_ids, a aws_ec2_transit_gateway_vpc_attachment is created to connect the VPC to the Transit Gateway. These attachments use the specified private subnet IDs.

3. VPN Gateway (VGW)
Creates a VPN Gateway (aws_vpn_gateway.vpn_gw) and attaches it to the first VPC in var.vpc_ids.

4. Customer Gateway (CGW)
Defines a Customer Gateway (aws_customer_gateway.cgw) for the on-premises network, with provided IP address, ASN, and connection type.

5. VPN Connection
Establishes a VPN connection (aws_vpn_connection.vpn_connection) between the Customer Gateway and the Transit Gateway.

6. Transit Gateway Route Table
Creates a custom TGW route table (aws_ec2_transit_gateway_route_table.tgw_route_table) for managing routing between VPCs and VPN.

7. TGW Routes
Creates routes in the TGW route table to enable VPC-to-VPC communication via the TGW.

📥 Input Variables
vpc_ids: List of VPC IDs to attach to the Transit Gateway.

private_subnets: List of private subnet ID lists corresponding to each VPC.

vpc_cidr_blocks: List of CIDR blocks for each VPC, used in routing.

customer_gateway_bgp_asn: BGP ASN for the on-prem Customer Gateway.

customer_gateway_ip: Public IP address of the Customer Gateway.

vpn_connection_type: VPN connection type (typically "ipsec.1").

🔧 Required Networking Configuration
On the On-Premises Side:
✅ Open UDP Ports 500 and 4500 in the firewall to allow IPsec/IKE traffic:

bash
Copy
Edit
sudo iptables -A INPUT -p udp --dport 500 -j ACCEPT
sudo iptables -A INPUT -p udp --dport 4500 -j ACCEPT
✅ Add a route to AWS VPC CIDRs through the VPN tunnel or associated ENI:

bash
Copy
Edit
sudo ip route add <VPC_CIDR> via <Tunnel_Endpoint_IP>
On the AWS Side:
✅ Attach the VPN Gateway to the first VPC using aws_vpn_gateway.vpn_gw.

✅ Ensure Security Groups and NACLs allow VPN traffic (UDP 500, 4500 and ESP - protocol 50).

🧭 Routing Notes
The configuration uses a round-robin approach to create routes between VPCs. Adjust the logic if you require more specific routing strategies.

You may also want to add static routes from VPC route tables pointing to the Transit Gateway for inter-VPC traffic.

✅ Example Terraform Usage
h
Copy
Edit
module "tgw_setup" {
  source = "./tgw-module"

  vpc_ids                = ["vpc-12345", "vpc-67890"]
  private_subnets        = [["subnet-a1", "subnet-a2"], ["subnet-b1", "subnet-b2"]]
  vpc_cidr_blocks        = ["10.0.0.0/16", "10.1.0.0/16"]
  customer_gateway_bgp_asn = 65001
  customer_gateway_ip      = "203.0.113.1"
  vpn_connection_type      = "ipsec.1"
}
