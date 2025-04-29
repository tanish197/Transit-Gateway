vpc_cidr_blocks = [
  "10.0.0.0/16",  # VPC 1 CIDR
  "10.2.0.0/16"   # VPC 2 CIDR
]

vpc_ids = [
  "vpc-0283de4fb93f112e6",  # VPC 1 ID
  "vpc-0e5517f232e34cd4f"   # VPC 2 ID
]

public_subnets = [
  ["subnet-0d3c07371e009eb9f", "subnet-0b9e7ecd7d239cbac"],  # Public subnets for VPC 1
  ["subnet-071aa85c57c8ac3d6", "subnet-0edfc10488764fc7b"]   # Public subnets for VPC 2
]

private_subnets = [
  ["subnet-08d39e0d844a91372", "subnet-058b592382ad267b8"],  # Private subnets for VPC 1
  ["subnet-0bbbef7e392e8e3ac", "subnet-0fdbe52d05a65394a"]   # Private subnets for VPC 2
]

customer_gateway_bgp_asn = 65000

customer_gateway_ip = "65.0.165.40"

vpn_connection_type = "ipsec.1"

aws_access_key = "ACCESSKEY"
aws_secret_key = "SECRETKEY"