variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "account_id" {
  type = number
  default = 121263836368
}

variable "environment" {
  type    = string
  default = "Development"
}

variable "aws_access_key" {
  type        = string
  description = "AWS access key"
  sensitive   = true
}

variable "aws_secret_key" {
  type        = string
  description = "AWS secret key"
  sensitive   = true
}

variable "vpc_cidr_blocks" {
  description = "List of CIDR blocks for existing VPCs"
  type        = list(string)
}

variable "vpc_ids" {
  description = "List of VPC IDs to which TGW will be attached"
  type        = list(string)
}

variable "public_subnets" {
  description = "List of public subnet IDs for each VPC"
  type        = list(list(string))
}

variable "private_subnets" {
  description = "List of private subnet IDs for each VPC"
  type        = list(list(string))
}

variable "customer_gateway_bgp_asn" {
  description = "BGP ASN for the customer gateway (on-premises network)"
  type        = number
}

variable "customer_gateway_ip" {
  description = "IP address of the customer gateway (on-premises network)"
  type        = string
}

variable "vpn_connection_type" {
  description = "Type of VPN connection (e.g., ipsec.1)"
  type        = string
}
