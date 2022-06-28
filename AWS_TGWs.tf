resource "aws_ec2_transit_gateway" "tgw_us_east" {
  description = "TGW in US-East-1"
  amazon_side_asn = var.asn_tgw_region1
  transit_gateway_cidr_blocks = var.cidr_tgw_region1
  default_route_table_association = "disable"
  default_route_table_propagation = "disable"
}

resource "aws_ec2_transit_gateway_vpc_attachment" "USE1_TGWtoProdVPC" {
  subnet_ids         = var.prod_app_subnet_region1
  transit_gateway_id = aws_ec2_transit_gateway.tgw_us_east.id
  vpc_id             = var.prod_app_vpc_region1
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false
}

resource "aws_ec2_transit_gateway_vpc_attachment" "USE1_TGWtoDevVPC" {
  subnet_ids         = var.dev_app_subnet_region1
  transit_gateway_id = aws_ec2_transit_gateway.tgw_us_east.id
  vpc_id             = var.dev_app_vpc_region1
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false
}

resource "aws_ec2_transit_gateway_vpc_attachment" "USE1_TGWtoTransitVPC" {
  #replace subnet IDs with the subnet IDs of the primary and HA gateway transit subnets
  subnet_ids         = ["replace_me","replace_me"]
  transit_gateway_id = aws_ec2_transit_gateway.tgw_us_east.id
  vpc_id             = module.transit_us_east.transit_gateway.vpc_id
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false
}

resource "aws_ec2_transit_gateway_connect" "USE1_Connect_Prod" {
  transport_attachment_id = aws_ec2_transit_gateway_vpc_attachment.USE1_TGWtoTransitVPC.id
  transit_gateway_id      = aws_ec2_transit_gateway.tgw_us_east.id
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false
}

resource "aws_ec2_transit_gateway_connect" "USE1_Connect_Dev" {
  transport_attachment_id = aws_ec2_transit_gateway_vpc_attachment.USE1_TGWtoTransitVPC.id
  transit_gateway_id      = aws_ec2_transit_gateway.tgw_us_east.id
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false
}

resource "aws_ec2_transit_gateway_connect_peer" "USE1_Peer_Prod1_1" {
  peer_address                  = module.transit_us_east.transit_gateway.private_ip
  inside_cidr_blocks            = var.tgw_inside_cidr_block_use1_prod1_1
  transit_gateway_attachment_id = aws_ec2_transit_gateway_connect.USE1_Connect_Prod.id
  bgp_asn                       = var.asn_transit1
  transit_gateway_address       = var.tgw_address_use1_prod1_1
}

resource "aws_ec2_transit_gateway_connect_peer" "USE1_Peer_Prod1_2" {
  peer_address                  = module.transit_us_east.transit_gateway.ha_private_ip
  inside_cidr_blocks            = var.tgw_inside_cidr_block_use1_prod1_2
  transit_gateway_attachment_id = aws_ec2_transit_gateway_connect.USE1_Connect_Prod.id
  bgp_asn                       = var.asn_transit1
  transit_gateway_address       = var.tgw_address_use1_prod1_2
}

resource "aws_ec2_transit_gateway_connect_peer" "USE1_Peer_Prod2_1" {
  peer_address                  = module.transit_us_east.transit_gateway.private_ip
  inside_cidr_blocks            = var.tgw_inside_cidr_block_use1_prod2_1
  transit_gateway_attachment_id = aws_ec2_transit_gateway_connect.USE1_Connect_Prod.id
  bgp_asn                       = var.asn_transit1
  transit_gateway_address       = var.tgw_address_use1_prod2_1
}

resource "aws_ec2_transit_gateway_connect_peer" "USE1_Peer_Prod2_2" {
  peer_address                  = module.transit_us_east.transit_gateway.ha_private_ip
  inside_cidr_blocks            = var.tgw_inside_cidr_block_use1_prod2_2
  transit_gateway_attachment_id = aws_ec2_transit_gateway_connect.USE1_Connect_Prod.id
  bgp_asn                       = var.asn_transit1
  transit_gateway_address       = var.tgw_address_use1_prod2_2
}

resource "aws_ec2_transit_gateway_connect_peer" "USE1_Peer_Dev1_1" {
  peer_address                  = module.transit_us_east.transit_gateway.private_ip
  inside_cidr_blocks            = var.tgw_inside_cidr_block_use1_dev1_1
  transit_gateway_attachment_id = aws_ec2_transit_gateway_connect.USE1_Connect_Dev.id
  bgp_asn                       = var.asn_transit1
  transit_gateway_address       = var.tgw_address_use1_dev1_1
}

resource "aws_ec2_transit_gateway_connect_peer" "USE1_Peer_Dev1_2" {
  peer_address                  = module.transit_us_east.transit_gateway.ha_private_ip
  inside_cidr_blocks            = var.tgw_inside_cidr_block_use1_dev1_2
  transit_gateway_attachment_id = aws_ec2_transit_gateway_connect.USE1_Connect_Dev.id
  bgp_asn                       = var.asn_transit1
  transit_gateway_address       = var.tgw_address_use1_dev1_2
}

resource "aws_ec2_transit_gateway_connect_peer" "USE1_Peer_Dev2_1" {
  peer_address                  = module.transit_us_east.transit_gateway.private_ip
  inside_cidr_blocks            = var.tgw_inside_cidr_block_use1_dev2_1
  transit_gateway_attachment_id = aws_ec2_transit_gateway_connect.USE1_Connect_Dev.id
  bgp_asn                       = var.asn_transit1
  transit_gateway_address       = var.tgw_address_use1_dev2_1
}

resource "aws_ec2_transit_gateway_connect_peer" "USE1_Peer_Dev2_2" {
  peer_address                  = module.transit_us_east.transit_gateway.ha_private_ip
  inside_cidr_blocks            = var.tgw_inside_cidr_block_use1_dev2_2
  transit_gateway_attachment_id = aws_ec2_transit_gateway_connect.USE1_Connect_Dev.id
  bgp_asn                       = var.asn_transit1
  transit_gateway_address       = var.tgw_address_use1_dev2_2
}

resource "aws_ec2_transit_gateway_route_table" "USE1_Prod_RT" {
  transit_gateway_id = aws_ec2_transit_gateway.tgw_us_east.id
}

resource "aws_ec2_transit_gateway_route_table_association" "USE1_Prod_RT_association" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.USE1_TGWtoProdVPC.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.USE1_Prod_RT.id
}

resource "aws_ec2_transit_gateway_route_table_association" "USE1_Prod_RT_association2" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_connect.USE1_Connect_Prod.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.USE1_Prod_RT.id
}

resource "aws_ec2_transit_gateway_route_table_propagation" "USE1_Prod_RT_propagation" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.USE1_TGWtoProdVPC.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.USE1_Prod_RT.id
}

resource "aws_ec2_transit_gateway_route_table_propagation" "USE1_Prod_RT_propagation2" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_connect.USE1_Connect_Prod.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.USE1_Prod_RT.id
}

resource "aws_ec2_transit_gateway_route_table" "USE1_Dev_RT" {
  transit_gateway_id = aws_ec2_transit_gateway.tgw_us_east.id
}

resource "aws_ec2_transit_gateway_route_table_association" "USE1_Dev_RT_association" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.USE1_TGWtoDevVPC.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.USE1_Dev_RT.id
}

resource "aws_ec2_transit_gateway_route_table_association" "USE1_Dev_RT_association2" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_connect.USE1_Connect_Dev.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.USE1_Dev_RT.id
}

resource "aws_ec2_transit_gateway_route_table_propagation" "USE1_Dev_RT_propagation" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.USE1_TGWtoDevVPC.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.USE1_Dev_RT.id
}

resource "aws_ec2_transit_gateway_route_table_propagation" "USE1_Dev_RT_propagation2" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_connect.USE1_Connect_Dev.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.USE1_Dev_RT.id
}

resource "aws_route" "USE1_AVX_VPC_to_TGW_route" {
  #replace route table ID with the RTB associated with the primary and HA gateway transit subnets
  route_table_id            = "replace_me"
  destination_cidr_block    = "192.168.101.0/24"
  transit_gateway_id = aws_ec2_transit_gateway.tgw_us_east.id
}


resource "aws_ec2_transit_gateway" "tgw_us_west" {
  description = "TGW in US-West-1"
  amazon_side_asn = var.asn_tgw_region2
  transit_gateway_cidr_blocks = var.cidr_tgw_region2
  default_route_table_association = "disable"
  default_route_table_propagation = "disable"
  provider = aws.west
}

resource "aws_ec2_transit_gateway_vpc_attachment" "USW2_TGWtoProdVPC" {
  subnet_ids         = var.prod_app_subnet_region2
  transit_gateway_id = aws_ec2_transit_gateway.tgw_us_west.id
  vpc_id             = var.prod_app_vpc_region2
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false
  provider = aws.west
}

resource "aws_ec2_transit_gateway_vpc_attachment" "USW2_TGWtoDevVPC" {
  subnet_ids         = var.dev_app_subnet_region2
  transit_gateway_id = aws_ec2_transit_gateway.tgw_us_west.id
  vpc_id             = var.dev_app_vpc_region2
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false
  provider = aws.west
}

resource "aws_ec2_transit_gateway_vpc_attachment" "USW2_TGWtoTransitVPC" {
  #replace subnet IDs with the subnet IDs of the primary and HA gateway transit subnets
  subnet_ids         = ["replace_me","replace_me"]
  transit_gateway_id = aws_ec2_transit_gateway.tgw_us_west.id
  vpc_id             = module.transit_us_west.transit_gateway.vpc_id
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false
  provider = aws.west
}

resource "aws_ec2_transit_gateway_connect" "USW2_Connect_Prod" {
  transport_attachment_id = aws_ec2_transit_gateway_vpc_attachment.USW2_TGWtoTransitVPC.id
  transit_gateway_id      = aws_ec2_transit_gateway.tgw_us_west.id
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false
  provider = aws.west
}

resource "aws_ec2_transit_gateway_connect" "USW2_Connect_Dev" {
  transport_attachment_id = aws_ec2_transit_gateway_vpc_attachment.USW2_TGWtoTransitVPC.id
  transit_gateway_id      = aws_ec2_transit_gateway.tgw_us_west.id
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false
  provider = aws.west
}

resource "aws_ec2_transit_gateway_connect_peer" "USW2_Peer_Prod1_1" {
  peer_address                  = module.transit_us_west.transit_gateway.private_ip
  inside_cidr_blocks            = var.tgw_inside_cidr_block_usw2_prod1_1
  transit_gateway_attachment_id = aws_ec2_transit_gateway_connect.USW2_Connect_Prod.id
  bgp_asn                       = var.asn_transit2
  transit_gateway_address       = var.tgw_address_usw2_prod1_1
  provider = aws.west
}

resource "aws_ec2_transit_gateway_connect_peer" "USW2_Peer_Prod1_2" {
  peer_address                  = module.transit_us_west.transit_gateway.ha_private_ip
  inside_cidr_blocks            = var.tgw_inside_cidr_block_usw2_prod1_2
  transit_gateway_attachment_id = aws_ec2_transit_gateway_connect.USW2_Connect_Prod.id
  bgp_asn                       = var.asn_transit2
  transit_gateway_address       = var.tgw_address_usw2_prod1_2
  provider = aws.west
}

resource "aws_ec2_transit_gateway_connect_peer" "USW2_Peer_Prod2_1" {
  peer_address                  = module.transit_us_west.transit_gateway.private_ip
  inside_cidr_blocks            = var.tgw_inside_cidr_block_usw2_prod2_1
  transit_gateway_attachment_id = aws_ec2_transit_gateway_connect.USW2_Connect_Prod.id
  bgp_asn                       = var.asn_transit2
  transit_gateway_address       = var.tgw_address_usw2_prod2_1
  provider = aws.west
}

resource "aws_ec2_transit_gateway_connect_peer" "USW2_Peer_Prod2_2" {
  peer_address                  = module.transit_us_west.transit_gateway.ha_private_ip
  inside_cidr_blocks            = var.tgw_inside_cidr_block_usw2_prod2_2
  transit_gateway_attachment_id = aws_ec2_transit_gateway_connect.USW2_Connect_Prod.id
  bgp_asn                       = var.asn_transit2
  transit_gateway_address       = var.tgw_address_usw2_prod2_2
  provider = aws.west
}

resource "aws_ec2_transit_gateway_connect_peer" "USW2_Peer_Dev1_1" {
  peer_address                  = module.transit_us_west.transit_gateway.private_ip
  inside_cidr_blocks            = var.tgw_inside_cidr_block_usw2_dev1_1
  transit_gateway_attachment_id = aws_ec2_transit_gateway_connect.USW2_Connect_Dev.id
  bgp_asn                       = var.asn_transit2
  transit_gateway_address       = var.tgw_address_usw2_dev1_1
  provider = aws.west
}

resource "aws_ec2_transit_gateway_connect_peer" "USW2_Peer_Dev1_2" {
  peer_address                  = module.transit_us_west.transit_gateway.ha_private_ip
  inside_cidr_blocks            = var.tgw_inside_cidr_block_usw2_dev1_2
  transit_gateway_attachment_id = aws_ec2_transit_gateway_connect.USW2_Connect_Dev.id
  bgp_asn                       = var.asn_transit2
  transit_gateway_address       = var.tgw_address_usw2_dev1_2
  provider = aws.west
}

resource "aws_ec2_transit_gateway_connect_peer" "USW2_Peer_Dev2_1" {
  peer_address                  = module.transit_us_west.transit_gateway.private_ip
  inside_cidr_blocks            = var.tgw_inside_cidr_block_usw2_dev2_1
  transit_gateway_attachment_id = aws_ec2_transit_gateway_connect.USW2_Connect_Dev.id
  bgp_asn                       = var.asn_transit2
  transit_gateway_address       = var.tgw_address_usw2_dev2_1
  provider = aws.west
}

resource "aws_ec2_transit_gateway_connect_peer" "USW2_Peer_Dev2_2" {
  peer_address                  = module.transit_us_west.transit_gateway.ha_private_ip
  inside_cidr_blocks            = var.tgw_inside_cidr_block_usw2_dev2_2
  transit_gateway_attachment_id = aws_ec2_transit_gateway_connect.USW2_Connect_Dev.id
  bgp_asn                       = var.asn_transit2
  transit_gateway_address       = var.tgw_address_usw2_dev2_2
  provider = aws.west
}

resource "aws_ec2_transit_gateway_route_table" "USW2_Prod_RT" {
  transit_gateway_id = aws_ec2_transit_gateway.tgw_us_west.id
  provider = aws.west
}

resource "aws_ec2_transit_gateway_route_table_association" "USW2_Prod_RT_association" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.USW2_TGWtoProdVPC.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.USW2_Prod_RT.id
  provider = aws.west
}

resource "aws_ec2_transit_gateway_route_table_association" "USW2_Prod_RT_association2" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_connect.USW2_Connect_Prod.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.USW2_Prod_RT.id
  provider = aws.west
}

resource "aws_ec2_transit_gateway_route_table_propagation" "USW2_Prod_RT_propagation" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.USW2_TGWtoProdVPC.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.USW2_Prod_RT.id
  provider = aws.west
}

resource "aws_ec2_transit_gateway_route_table_propagation" "USW2_Prod_RT_propagation2" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_connect.USW2_Connect_Prod.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.USW2_Prod_RT.id
  provider = aws.west
}

resource "aws_ec2_transit_gateway_route_table" "USW2_Dev_RT" {
  transit_gateway_id = aws_ec2_transit_gateway.tgw_us_west.id
  provider = aws.west
}

resource "aws_ec2_transit_gateway_route_table_association" "USW2_Dev_RT_association" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.USW2_TGWtoDevVPC.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.USW2_Dev_RT.id
  provider = aws.west
}

resource "aws_ec2_transit_gateway_route_table_association" "USW2_Dev_RT_association2" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_connect.USW2_Connect_Dev.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.USW2_Dev_RT.id
  provider = aws.west
}

resource "aws_ec2_transit_gateway_route_table_propagation" "USW2_Dev_RT_propagation" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.USW2_TGWtoDevVPC.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.USW2_Dev_RT.id
  provider = aws.west
}

resource "aws_ec2_transit_gateway_route_table_propagation" "USW2_Dev_RT_propagation2" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_connect.USW2_Connect_Dev.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.USW2_Dev_RT.id
  provider = aws.west
}

resource "aws_route" "USW2_AVX_VPC_to_TGW_route" {
  #replace route table ID with the RTB associated with the primary and HA gateway transit subnets
  route_table_id            = "replace_me"
  destination_cidr_block    = "192.168.201.0/24"
  transit_gateway_id = aws_ec2_transit_gateway.tgw_us_west.id
  provider = aws.west
}
