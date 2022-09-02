# Customer VPC Creation

module "use1_prod_vpc" {
  source = "terraform-aws-modules/vpc/aws"
  name = "use1-app-prod-vpc"
  cidr = "10.51.0.0/16"
  azs = ["us-east-1a"]
  private_subnets = ["10.51.1.0/24"]
  public_subnets = ["10.51.2.0/24"]
  enable_nat_gateway = true
}

module "use1_dev_vpc" {
  source = "terraform-aws-modules/vpc/aws"
  name = "use1-app-dev-vpc"
  cidr = "10.52.0.0/16"
  azs = ["us-east-1a"]
  private_subnets = ["10.52.1.0/24"]
  public_subnets = ["10.52.2.0/24"]
  enable_nat_gateway = true
}

module "usw2_prod_vpc" {
  source = "terraform-aws-modules/vpc/aws"
  name = "usw2-app-prod-vpc"
  cidr = "10.61.0.0/16"
  azs = ["us-west-2a"]
  private_subnets = ["10.61.1.0/24"]
  public_subnets = ["10.61.2.0/24"]
  enable_nat_gateway = true
  providers = {
    aws = aws.west
   }
}

module "usw2_dev_vpc" {
  source = "terraform-aws-modules/vpc/aws"
  name = "usw2-app-dev-vpc"
  cidr = "10.62.0.0/16"
  azs = ["us-west-2a"]
  private_subnets = ["10.62.1.0/24"]
  public_subnets = ["10.62.2.0/24"]
  enable_nat_gateway = true
  providers = {
    aws = aws.west
   }
}

# US-East-1 Configuration

resource "aws_ec2_transit_gateway" "tgw_us_east" {
  description = "TGW in US-East-1"
  amazon_side_asn = var.asn_tgw_region1
  transit_gateway_cidr_blocks = var.cidr_tgw_region1
  default_route_table_association = "disable"
  default_route_table_propagation = "disable"
}

resource "aws_ec2_transit_gateway_vpc_attachment" "USE1_TGWtoProdVPC" {
  subnet_ids         = module.use1_prod_vpc.public_subnets
  transit_gateway_id = aws_ec2_transit_gateway.tgw_us_east.id
  vpc_id             = module.use1_prod_vpc.vpc_id
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false
  depends_on = [
    module.use1_prod_vpc
  ]
}

resource "aws_ec2_transit_gateway_vpc_attachment" "USE1_TGWtoDevVPC" {
  subnet_ids         = module.use1_dev_vpc.public_subnets
  transit_gateway_id = aws_ec2_transit_gateway.tgw_us_east.id
  vpc_id             = module.use1_dev_vpc.vpc_id
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false
  depends_on = [
    module.use1_dev_vpc
  ]
}

resource "aws_ec2_transit_gateway_vpc_attachment" "USE1_TGWtoTransitVPC" {
  subnet_ids = [module.transit_us_east.vpc.subnets[0].subnet_id,module.transit_us_east.vpc.subnets[2].subnet_id]
  transit_gateway_id = aws_ec2_transit_gateway.tgw_us_east.id
  vpc_id             = module.transit_us_east.transit_gateway.vpc_id
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false
  depends_on = [
    module.transit_us_east
  ]
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

resource "aws_route" "USE1_AVX_VPC_to_TGW_route0" {
  route_table_id = module.transit_us_east.vpc.route_tables[0]
  destination_cidr_block    = var.tgw_region1_cidr_block
  transit_gateway_id = aws_ec2_transit_gateway.tgw_us_east.id
  depends_on = [
    aws_ec2_transit_gateway.tgw_us_east,
    module.transit_us_east
  ]
}

resource "aws_route" "USE1_AVX_VPC_to_TGW_route1" {
  route_table_id = module.transit_us_east.vpc.route_tables[1]
  destination_cidr_block    = var.tgw_region1_cidr_block
  transit_gateway_id = aws_ec2_transit_gateway.tgw_us_east.id
  depends_on = [
    aws_ec2_transit_gateway.tgw_us_east,
    module.transit_us_east
  ]
}

resource "aws_route" "USE1_AVX_VPC_to_TGW_route2" {
  route_table_id = module.transit_us_east.vpc.route_tables[2]
  destination_cidr_block    = var.tgw_region1_cidr_block
  transit_gateway_id = aws_ec2_transit_gateway.tgw_us_east.id
  depends_on = [
    aws_ec2_transit_gateway.tgw_us_east,
    module.transit_us_east.transit_gateway
  ]
}

resource "aws_route" "USE1_prod_VPC_route" {
  route_table_id = module.use1_prod_vpc.public_route_table_ids[0]
  destination_cidr_block    = "10.0.0.0/8"
  transit_gateway_id = aws_ec2_transit_gateway.tgw_us_east.id
  depends_on = [
    aws_ec2_transit_gateway.tgw_us_east,
    module.use1_prod_vpc
  ]
}

resource "aws_route" "USE1_dev_VPC_route" {
  route_table_id = module.use1_dev_vpc.public_route_table_ids[0]
  destination_cidr_block    = "10.0.0.0/8"
  transit_gateway_id = aws_ec2_transit_gateway.tgw_us_east.id
  depends_on = [
    aws_ec2_transit_gateway.tgw_us_east,
    module.use1_dev_vpc
  ]
}


# US-West-2 Configuration

resource "aws_ec2_transit_gateway" "tgw_us_west" {
  description = "TGW in US-West-1"
  amazon_side_asn = var.asn_tgw_region2
  transit_gateway_cidr_blocks = var.cidr_tgw_region2
  default_route_table_association = "disable"
  default_route_table_propagation = "disable"
  provider = aws.west
}

resource "aws_ec2_transit_gateway_vpc_attachment" "USW2_TGWtoProdVPC" {
  subnet_ids         = module.usw2_prod_vpc.public_subnets
  transit_gateway_id = aws_ec2_transit_gateway.tgw_us_west.id
  vpc_id             = module.usw2_prod_vpc.vpc_id
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false
  provider = aws.west
  depends_on = [
    module.usw2_prod_vpc
  ]
}

resource "aws_ec2_transit_gateway_vpc_attachment" "USW2_TGWtoDevVPC" {
  subnet_ids         = module.usw2_dev_vpc.public_subnets
  transit_gateway_id = aws_ec2_transit_gateway.tgw_us_west.id
  vpc_id             = module.usw2_dev_vpc.vpc_id
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false
  provider = aws.west
  depends_on = [
    module.usw2_dev_vpc
  ]
}

resource "aws_ec2_transit_gateway_vpc_attachment" "USW2_TGWtoTransitVPC" {
  subnet_ids = [module.transit_us_west.vpc.subnets[0].subnet_id,module.transit_us_west.vpc.subnets[2].subnet_id]
  transit_gateway_id = aws_ec2_transit_gateway.tgw_us_west.id
  vpc_id             = module.transit_us_west.transit_gateway.vpc_id
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false
  provider = aws.west
  depends_on = [
    module.transit_us_east
  ]
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

resource "aws_route" "USW2_AVX_VPC_to_TGW_route0" {
  route_table_id = module.transit_us_west.vpc.route_tables[0]
  destination_cidr_block    = var.tgw_region2_cidr_block
  transit_gateway_id = aws_ec2_transit_gateway.tgw_us_west.id
  depends_on = [
    aws_ec2_transit_gateway.tgw_us_west,
    module.transit_us_west
  ]
  provider = aws.west
}

resource "aws_route" "USW2_AVX_VPC_to_TGW_route1" {
  route_table_id = module.transit_us_west.vpc.route_tables[1]
  destination_cidr_block    = var.tgw_region2_cidr_block
  transit_gateway_id = aws_ec2_transit_gateway.tgw_us_west.id
  depends_on = [
    aws_ec2_transit_gateway.tgw_us_west,
    module.transit_us_west
  ]
  provider = aws.west
}

resource "aws_route" "USW2_AVX_VPC_to_TGW_route2" {
  route_table_id = module.transit_us_west.vpc.route_tables[2]
  destination_cidr_block    = var.tgw_region2_cidr_block
  transit_gateway_id = aws_ec2_transit_gateway.tgw_us_west.id
  depends_on = [
    aws_ec2_transit_gateway.tgw_us_west,
    module.transit_us_west.transit_gateway
  ]
  provider = aws.west
}

resource "aws_route" "USW2_prod_VPC_route" {
  route_table_id = module.usw2_prod_vpc.public_route_table_ids[0]
  destination_cidr_block    = "10.0.0.0/8"
  transit_gateway_id = aws_ec2_transit_gateway.tgw_us_west.id
  depends_on = [
    aws_ec2_transit_gateway.tgw_us_west,
    module.usw2_prod_vpc
  ]
  provider = aws.west
}

resource "aws_route" "USW2_dev_VPC_route" {
  route_table_id = module.usw2_dev_vpc.public_route_table_ids[0]
  destination_cidr_block    = "10.0.0.0/8"
  transit_gateway_id = aws_ec2_transit_gateway.tgw_us_west.id
  depends_on = [
    aws_ec2_transit_gateway.tgw_us_west,
    module.usw2_dev_vpc
  ]
  provider = aws.west
}
