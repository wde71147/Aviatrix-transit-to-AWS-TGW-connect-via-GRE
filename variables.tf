variable "controller2_ip" {
  type = string
  default = "replace_me"
}

variable "password" {
   description = "password"
   type = string
   default = "replace_me"
   }

variable "aws_account" {
  description = "AWS account used for provisioning"
  type = string
  default = "replace_me"
}
variable region1 {
  default = "us-east-1"
}
variable region2 {
  default = "us-west-2"
}

variable transitname1 {
  default = "us-east-1-transit-gw"
}

variable transitname2 {
  default = "us-west-2-transit-gw"
}

variable transit_gw_size {
  default = "c5n.4xlarge"
}

variable transit_cidr1 {
   default = "172.101.0.0/16"
}

variable transit_cidr2 {
   default = "172.201.0.0/16"
}

variable asn_transit1 {
   default = "65101"
}

variable asn_transit2 {
   default = "65201"
}

variable asn_tgw_region1 {
   default = "65102"
}

variable asn_tgw_region2 {
   default = "65202"
}

variable cidr_tgw_region1 {
  default = ["192.168.101.0/24"]
}

variable cidr_tgw_region2 {
  default = ["192.168.201.0/24"]
}

variable prod_app_vpc_region1 {
  default = "replace_me"
}

variable prod_app_subnet_region1 {
  default = ["replace_me"]
}

variable dev_app_vpc_region1 {
  default = "replace_me"
}

variable dev_app_subnet_region1 {
  default = ["replace_me"]
}

variable prod_app_vpc_region2 {
  default = "replace_me"
}

variable prod_app_subnet_region2 {
  default = ["replace_me"]
}

variable dev_app_vpc_region2 {
  default = "replace_me"
}

variable dev_app_subnet_region2 {
  default = ["replace_me"]
}

variable connection_name_use1_prod_1 {
  default = "USE1_AVXtoTGW_prod_1"
}

variable remote_gateway_ip_use1_prod_1 {
  default = "192.168.101.1,192.168.101.2"
}

variable local_tunnel_cidr_use1_prod_1 {
  default = "169.254.101.1/29,169.254.101.9/29"
}

variable remote_tunnel_cidr_use1_prod_1 {
  default = "169.254.101.2/29,169.254.101.10/29"
}

variable tgw_inside_cidr_block_use1_prod1_1 {
  default = ["169.254.101.0/29"]
}

variable tgw_inside_cidr_block_use1_prod1_2 {
  default = ["169.254.101.8/29"]
}

variable tgw_address_use1_prod1_1 {
  default = "192.168.101.1"
}

variable tgw_address_use1_prod1_2 {
  default = "192.168.101.2"
}

variable connection_name_use1_prod_2 {
  default = "USE1_AVXtoTGW_prod_2"
}

variable remote_gateway_ip_use1_prod_2 {
  default = "192.168.101.3,192.168.101.4"
}

variable local_tunnel_cidr_use1_prod_2 {
  default = "169.254.101.17/29,169.254.101.25/29"
}

variable remote_tunnel_cidr_use1_prod_2 {
  default = "169.254.101.18/29,169.254.101.26/29"
}

variable tgw_inside_cidr_block_use1_prod2_1 {
  default = ["169.254.101.16/29"]
}

variable tgw_inside_cidr_block_use1_prod2_2 {
  default = ["169.254.101.24/29"]
}

variable tgw_address_use1_prod2_1 {
  default = "192.168.101.3"
}

variable tgw_address_use1_prod2_2 {
  default = "192.168.101.4"
}

variable connection_name_use1_dev_1 {
  default = "USE1_AVXtoTGW_dev_1"
}

variable remote_gateway_ip_use1_dev_1 {
  default = "192.168.101.5,192.168.101.6"
}

variable local_tunnel_cidr_use1_dev_1 {
  default = "169.254.101.33/29,169.254.101.41/29"
}

variable remote_tunnel_cidr_use1_dev_1 {
  default = "169.254.101.34/29,169.254.101.42/29"
}

variable tgw_inside_cidr_block_use1_dev1_1 {
  default = ["169.254.101.32/29"]
}

variable tgw_inside_cidr_block_use1_dev1_2 {
  default = ["169.254.101.40/29"]
}

variable tgw_address_use1_dev1_1 {
  default = "192.168.101.5"
}

variable tgw_address_use1_dev1_2 {
  default = "192.168.101.6"
}

variable connection_name_use1_dev_2 {
  default = "USE1_AVXtoTGW_dev_2"
}

variable remote_gateway_ip_use1_dev_2 {
  default = "192.168.101.7,192.168.101.8"
}

variable local_tunnel_cidr_use1_dev_2 {
  default = "169.254.101.49/29,169.254.101.57/29"
}

variable remote_tunnel_cidr_use1_dev_2 {
  default = "169.254.101.50/29,169.254.101.58/29"
}

variable tgw_inside_cidr_block_use1_dev2_1 {
  default = ["169.254.101.48/29"]
}

variable tgw_inside_cidr_block_use1_dev2_2 {
  default = ["169.254.101.56/29"]
}

variable tgw_address_use1_dev2_1 {
  default = "192.168.101.7"
}

variable tgw_address_use1_dev2_2 {
  default = "192.168.101.8"
}

variable connection_name_usw2_prod_1 {
  default = "USW2_AVXtoTGW_prod_1"
}

variable remote_gateway_ip_usw2_prod_1 {
  default = "192.168.201.1,192.168.201.2"
}

variable local_tunnel_cidr_usw2_prod_1 {
  default = "169.254.201.1/29,169.254.201.9/29"
}

variable remote_tunnel_cidr_usw2_prod_1 {
  default = "169.254.201.2/29,169.254.201.10/29"
}

variable tgw_inside_cidr_block_usw2_prod1_1 {
  default = ["169.254.201.0/29"]
}

variable tgw_inside_cidr_block_usw2_prod1_2 {
  default = ["169.254.201.8/29"]
}

variable tgw_address_usw2_prod1_1 {
  default = "192.168.201.1"
}

variable tgw_address_usw2_prod1_2 {
  default = "192.168.201.2"
}

variable connection_name_usw2_prod_2 {
  default = "USW2_AVXtoTGW_prod_2"
}

variable remote_gateway_ip_usw2_prod_2 {
  default = "192.168.201.3,192.168.201.4"
}

variable local_tunnel_cidr_usw2_prod_2 {
  default = "169.254.201.17/29,169.254.201.25/29"
}

variable remote_tunnel_cidr_usw2_prod_2 {
  default = "169.254.201.18/29,169.254.201.26/29"
}

variable tgw_inside_cidr_block_usw2_prod2_1 {
  default = ["169.254.201.16/29"]
}

variable tgw_inside_cidr_block_usw2_prod2_2 {
  default = ["169.254.201.24/29"]
}

variable tgw_address_usw2_prod2_1 {
  default = "192.168.201.3"
}

variable tgw_address_usw2_prod2_2 {
  default = "192.168.201.4"
}

variable connection_name_usw2_dev_1 {
  default = "USW2_AVXtoTGW_dev_1"
}

variable remote_gateway_ip_usw2_dev_1 {
  default = "192.168.201.5,192.168.201.6"
}

variable local_tunnel_cidr_usw2_dev_1 {
  default = "169.254.201.33/29,169.254.201.41/29"
}

variable remote_tunnel_cidr_usw2_dev_1 {
  default = "169.254.201.34/29,169.254.201.42/29"
}

variable tgw_inside_cidr_block_usw2_dev1_1 {
  default = ["169.254.201.32/29"]
}

variable tgw_inside_cidr_block_usw2_dev1_2 {
  default = ["169.254.201.40/29"]
}

variable tgw_address_usw2_dev1_1 {
  default = "192.168.201.5"
}

variable tgw_address_usw2_dev1_2 {
  default = "192.168.201.6"
}

variable connection_name_usw2_dev_2 {
  default = "USW2_AVXtoTGW_dev_2"
}

variable remote_gateway_ip_usw2_dev_2 {
  default = "192.168.201.7,192.168.201.8"
}

variable local_tunnel_cidr_usw2_dev_2 {
  default = "169.254.201.49/29,169.254.201.57/29"
}

variable remote_tunnel_cidr_usw2_dev_2 {
  default = "169.254.201.50/29,169.254.201.58/29"
}

variable tgw_inside_cidr_block_usw2_dev2_1 {
  default = ["169.254.201.48/29"]
}

variable tgw_inside_cidr_block_usw2_dev2_2 {
  default = ["169.254.201.56/29"]
}

variable tgw_address_usw2_dev2_1 {
  default = "192.168.201.7"
}

variable tgw_address_usw2_dev2_2 {
  default = "192.168.201.8"
}

variable "manual_bgp_adv_cidrs_prod" {
  description = "Configure manual BGP advertised CIDRs for this connection. Only valid with connection_type= 'bgp'."
  default = ["10.254.0.0/16","10.200.0.0/16","10.201.20.0/24","10.51.0.0/16","10.61.0.0/16","172.101.0.0/16","172.201.0.0/16"]
}

variable "manual_bgp_adv_cidrs_dev" {
  description = "Configure manual BGP advertised CIDRs for this connection. Only valid with connection_type= 'bgp'."
  default = ["10.253.0.0/16","10.100.0.0/16","10.101.20.0/24","10.52.0.0/16","10.62.0.0/16","172.101.0.0/16","172.201.0.0/16"]
}
