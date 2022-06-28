resource "aviatrix_segmentation_network_domain" "prod_domain" {
  domain_name = "prod"
  depends_on = [
    module.transit_us_east.transit_gateway,
    module.transit_us_west.transit_gateway
  ]
}

resource "aviatrix_segmentation_network_domain" "dev_domain" {
  domain_name = "dev"
  depends_on = [
    module.transit_us_east.transit_gateway,
    module.transit_us_west.transit_gateway
  ]
}

module "transit_us_east" {
  source  = "terraform-aviatrix-modules/mc-transit/aviatrix"
  version = "2.1.4"
  cloud = "AWS"
  name = var.transitname1
  cidr = var.transit_cidr1
  region = var.region1
  account = var.aws_account
  instance_size = var.transit_gw_size
  insane_mode = true
  enable_segmentation = true
  local_as_number = var.asn_transit1
  bgp_ecmp = true
  connected_transit = true
  enable_s2c_rx_balancing = true
  enable_advertise_transit_cidr = true
}

  
module "transit_us_west" {
  source  = "terraform-aviatrix-modules/mc-transit/aviatrix"
  version = "2.1.4"
  cloud = "AWS"
  name = var.transitname2
  cidr = var.transit_cidr2
  region = var.region2
  account = var.aws_account
  instance_size = var.transit_gw_size
  insane_mode = true
  enable_segmentation = true
  local_as_number = var.asn_transit2
  bgp_ecmp = true
  connected_transit = true
  enable_s2c_rx_balancing = true
  enable_advertise_transit_cidr = true
}
  
module "transit-peering" {
  source  = "git::https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-transit-peering"
  #version = "1.0.6"
  transit_gateways = [
    module.transit_us_east.transit_gateway.gw_name,
    module.transit_us_west.transit_gateway.gw_name
  ]
}
 
resource "aviatrix_transit_external_device_conn" "USE1_AVXtoTGW_prod_1" {
  vpc_id            = module.transit_us_east.transit_gateway.vpc_id
  connection_name   = var.connection_name_use1_prod_1
  gw_name           = module.transit_us_east.transit_gateway.gw_name
  connection_type   = "bgp"
  bgp_local_as_num  = module.transit_us_east.transit_gateway.local_as_number
  bgp_remote_as_num = var.asn_tgw_region1
  remote_gateway_ip = var.remote_gateway_ip_use1_prod_1
  tunnel_protocol   = "GRE"
  local_tunnel_cidr = var.local_tunnel_cidr_use1_prod_1
  remote_tunnel_cidr = var.remote_tunnel_cidr_use1_prod_1
  manual_bgp_advertised_cidrs = var.manual_bgp_adv_cidrs_prod
}

resource "aviatrix_transit_external_device_conn" "USE1_AVXtoTGW_prod_2" {
  vpc_id            = module.transit_us_east.transit_gateway.vpc_id
  connection_name   = var.connection_name_use1_prod_2
  gw_name           = module.transit_us_east.transit_gateway.gw_name
  connection_type   = "bgp"
  bgp_local_as_num  = module.transit_us_east.transit_gateway.local_as_number
  bgp_remote_as_num = var.asn_tgw_region1
  remote_gateway_ip = var.remote_gateway_ip_use1_prod_2
  tunnel_protocol   = "GRE"
  local_tunnel_cidr = var.local_tunnel_cidr_use1_prod_2
  remote_tunnel_cidr = var.remote_tunnel_cidr_use1_prod_2
  manual_bgp_advertised_cidrs = var.manual_bgp_adv_cidrs_prod
}

resource "aviatrix_transit_external_device_conn" "USE1_AVXtoTGW_dev_1" {
  vpc_id            = module.transit_us_east.transit_gateway.vpc_id
  connection_name   = var.connection_name_use1_dev_1
  gw_name           = module.transit_us_east.transit_gateway.gw_name
  connection_type   = "bgp"
  bgp_local_as_num  = module.transit_us_east.transit_gateway.local_as_number
  bgp_remote_as_num = var.asn_tgw_region1
  remote_gateway_ip = var.remote_gateway_ip_use1_dev_1
  tunnel_protocol   = "GRE"
  local_tunnel_cidr = var.local_tunnel_cidr_use1_dev_1
  remote_tunnel_cidr = var.remote_tunnel_cidr_use1_dev_1
  manual_bgp_advertised_cidrs = var.manual_bgp_adv_cidrs_dev
}

resource "aviatrix_transit_external_device_conn" "USE1_AVXtoTGW_dev_2" {
  vpc_id            = module.transit_us_east.transit_gateway.vpc_id
  connection_name   = var.connection_name_use1_dev_2
  gw_name           = module.transit_us_east.transit_gateway.gw_name
  connection_type   = "bgp"
  bgp_local_as_num  = module.transit_us_east.transit_gateway.local_as_number
  bgp_remote_as_num = var.asn_tgw_region1
  remote_gateway_ip = var.remote_gateway_ip_use1_dev_2
  tunnel_protocol   = "GRE"
  local_tunnel_cidr = var.local_tunnel_cidr_use1_dev_2
  remote_tunnel_cidr = var.remote_tunnel_cidr_use1_dev_2
  manual_bgp_advertised_cidrs = var.manual_bgp_adv_cidrs_dev
}


resource "aviatrix_transit_external_device_conn" "USW2_AVXtoTGW_prod_1" {
  vpc_id            = module.transit_us_west.transit_gateway.vpc_id
  connection_name   = var.connection_name_usw2_prod_1
  gw_name           = module.transit_us_west.transit_gateway.gw_name
  connection_type   = "bgp"
  bgp_local_as_num  = module.transit_us_west.transit_gateway.local_as_number
  bgp_remote_as_num = var.asn_tgw_region2
  remote_gateway_ip = var.remote_gateway_ip_usw2_prod_1
  tunnel_protocol   = "GRE"
  local_tunnel_cidr = var.local_tunnel_cidr_usw2_prod_1
  remote_tunnel_cidr = var.remote_tunnel_cidr_usw2_prod_1
  manual_bgp_advertised_cidrs = var.manual_bgp_adv_cidrs_prod
}

resource "aviatrix_transit_external_device_conn" "USW2_AVXtoTGW_prod_2" {
  vpc_id            = module.transit_us_west.transit_gateway.vpc_id
  connection_name   = var.connection_name_usw2_prod_2
  gw_name           = module.transit_us_west.transit_gateway.gw_name
  connection_type   = "bgp"
  bgp_local_as_num  = module.transit_us_west.transit_gateway.local_as_number
  bgp_remote_as_num = var.asn_tgw_region2
  remote_gateway_ip = var.remote_gateway_ip_usw2_prod_2
  tunnel_protocol   = "GRE"
  local_tunnel_cidr = var.local_tunnel_cidr_usw2_prod_2
  remote_tunnel_cidr = var.remote_tunnel_cidr_usw2_prod_2
  manual_bgp_advertised_cidrs = var.manual_bgp_adv_cidrs_prod
}

resource "aviatrix_transit_external_device_conn" "USW2_AVXtoTGW_dev_1" {
  vpc_id            = module.transit_us_west.transit_gateway.vpc_id
  connection_name   = var.connection_name_usw2_dev_1
  gw_name           = module.transit_us_west.transit_gateway.gw_name
  connection_type   = "bgp"
  bgp_local_as_num  = module.transit_us_west.transit_gateway.local_as_number
  bgp_remote_as_num = var.asn_tgw_region2
  remote_gateway_ip = var.remote_gateway_ip_usw2_dev_1
  tunnel_protocol   = "GRE"
  local_tunnel_cidr = var.local_tunnel_cidr_usw2_dev_1
  remote_tunnel_cidr = var.remote_tunnel_cidr_usw2_dev_1
  manual_bgp_advertised_cidrs = var.manual_bgp_adv_cidrs_dev
}

resource "aviatrix_transit_external_device_conn" "USW2_AVXtoTGW_dev_2" {
  vpc_id            = module.transit_us_west.transit_gateway.vpc_id
  connection_name   = var.connection_name_usw2_dev_2
  gw_name           = module.transit_us_west.transit_gateway.gw_name
  connection_type   = "bgp"
  bgp_local_as_num  = module.transit_us_west.transit_gateway.local_as_number
  bgp_remote_as_num = var.asn_tgw_region2
  remote_gateway_ip = var.remote_gateway_ip_usw2_dev_2
  tunnel_protocol   = "GRE"
  local_tunnel_cidr = var.local_tunnel_cidr_usw2_dev_2
  remote_tunnel_cidr = var.remote_tunnel_cidr_usw2_dev_2
  manual_bgp_advertised_cidrs = var.manual_bgp_adv_cidrs_dev
}

resource "aviatrix_segmentation_network_domain_association" "USE1_AVXtoTGW_prod_1_association" {
  transit_gateway_name = module.transit_us_east.transit_gateway.gw_name
  network_domain_name  = "prod"
  attachment_name      = var.connection_name_use1_prod_1
  depends_on = [
    aviatrix_transit_external_device_conn.USE1_AVXtoTGW_prod_1,
    aviatrix_segmentation_network_domain.prod_domain
  ]
}

resource "aviatrix_segmentation_network_domain_association" "USE1_AVXtoTGW_prod_2_association" {
  transit_gateway_name = module.transit_us_east.transit_gateway.gw_name
  network_domain_name  = "prod"
  attachment_name      = var.connection_name_use1_prod_2
  depends_on = [
    aviatrix_transit_external_device_conn.USE1_AVXtoTGW_prod_2,
    aviatrix_segmentation_network_domain.prod_domain
  ]
}

resource "aviatrix_segmentation_network_domain_association" "USE1_AVXtoTGW_dev_1_association" {
  transit_gateway_name = module.transit_us_east.transit_gateway.gw_name
  network_domain_name  = "dev"
  attachment_name      = var.connection_name_use1_dev_1
  depends_on = [
    aviatrix_transit_external_device_conn.USE1_AVXtoTGW_dev_1,
    aviatrix_segmentation_network_domain.dev_domain
  ]
}

resource "aviatrix_segmentation_network_domain_association" "USE1_AVXtoTGW_dev_2_association" {
  transit_gateway_name = module.transit_us_east.transit_gateway.gw_name
  network_domain_name  = "dev"
  attachment_name      = var.connection_name_use1_dev_2
  depends_on = [
    aviatrix_transit_external_device_conn.USE1_AVXtoTGW_dev_2,
    aviatrix_segmentation_network_domain.dev_domain
  ]
}

resource "aviatrix_segmentation_network_domain_association" "USW2_AVXtoTGW_prod_1_association" {
  transit_gateway_name = module.transit_us_west.transit_gateway.gw_name
  network_domain_name  = "prod"
  attachment_name      = var.connection_name_usw2_prod_1
  depends_on = [
    aviatrix_transit_external_device_conn.USW2_AVXtoTGW_prod_1,
    aviatrix_segmentation_network_domain.prod_domain
  ]
}

resource "aviatrix_segmentation_network_domain_association" "USW2_AVXtoTGW_prod_2_association" {
  transit_gateway_name = module.transit_us_west.transit_gateway.gw_name
  network_domain_name  = "prod"
  attachment_name      = var.connection_name_usw2_prod_2
  depends_on = [
    aviatrix_transit_external_device_conn.USW2_AVXtoTGW_prod_2,
    aviatrix_segmentation_network_domain.prod_domain
  ]
}

resource "aviatrix_segmentation_network_domain_association" "USW2_AVXtoTGW_dev_1_association" {
  transit_gateway_name = module.transit_us_west.transit_gateway.gw_name
  network_domain_name  = "dev"
  attachment_name      = var.connection_name_usw2_dev_1
  depends_on = [
    aviatrix_transit_external_device_conn.USW2_AVXtoTGW_dev_1,
    aviatrix_segmentation_network_domain.dev_domain
  ]
}

resource "aviatrix_segmentation_network_domain_association" "USW2_AVXtoTGW_dev_2_association" {
  transit_gateway_name = module.transit_us_west.transit_gateway.gw_name
  network_domain_name  = "dev"
  attachment_name      = var.connection_name_usw2_dev_2
  depends_on = [
    aviatrix_transit_external_device_conn.USW2_AVXtoTGW_dev_2,
    aviatrix_segmentation_network_domain.dev_domain
  ]
}
