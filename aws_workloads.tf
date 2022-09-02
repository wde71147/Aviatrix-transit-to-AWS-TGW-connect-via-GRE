locals {
  use1_prod_1_vm_user_data = <<EOF
#!/bin/bash
sudo hostnamectl set-hostname "use1-prod-1-vm"
sudo apt update -y
sudo apt upgrade -y
sudo apt-get -y install traceroute unzip build-essential git gcc hping3 apache2 net-tools iperf3
sudo apt autoremove
sudo echo "<html><h1>Aviatrix is awesome from use1-prod-1</h1></html>" > /var/www/html/index.html 
EOF
}

module "security_group_useast1prod1_workload" {
  source              = "terraform-aws-modules/security-group/aws"
  version             = "~> 3.0"
  name                = "use1-prod1-sg"
  description         = "Security group for example usage with EC2 instance"
  vpc_id              = module.use1_prod_vpc.vpc_id
  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["ssh-tcp", "all-icmp","http-80-tcp"]
  ingress_with_cidr_blocks = [
    {
      from_port   = 5201
      to_port     = 5201
      protocol    = "tcp"
      description = "iperf3"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
  egress_rules        = ["all-all"]
  depends_on = [
    module.use1_prod_vpc
  ]
}

module "use1_prod_1_workload" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"
  name = "use1-prod-1-workload"
  ami                    = "ami-08d4ac5b634553e16"
  instance_type          = "t2.micro"
  key_name               = "keypair_name"
  subnet_id              = module.use1_prod_vpc.public_subnets[0]
  vpc_security_group_ids = [module.security_group_useast1prod1_workload.this_security_group_id]
  associate_public_ip_address = true
  user_data_base64       = base64encode(local.use1_prod_1_vm_user_data)
  depends_on = [
    module.use1_prod_vpc
  ]
}

output "use1_prod_1_workload_public_ip" {
  value = module.use1_prod_1_workload.public_ip
}

output "use1_prod_1_workload_private_ip" {
  value = module.use1_prod_1_workload.private_ip
}

locals {
  use1_dev_1_vm_user_data = <<EOF
#!/bin/bash
sudo hostnamectl set-hostname "use1-dev-1-vm"
sudo apt update -y
sudo apt upgrade -y
sudo apt-get -y install traceroute unzip build-essential git gcc hping3 apache2 net-tools iperf3
sudo apt autoremove
sudo echo "<html><h1>Aviatrix is awesome from use1-dev-1</h1></html>" > /var/www/html/index.html 
EOF
}

module "security_group_useast1dev1_workload" {
  source              = "terraform-aws-modules/security-group/aws"
  version             = "~> 3.0"
  name                = "use1-dev1-sg"
  description         = "Security group for example usage with EC2 instance"
  vpc_id              = module.use1_dev_vpc.vpc_id
  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["ssh-tcp", "all-icmp","http-80-tcp"]
  ingress_with_cidr_blocks = [
    {
      from_port   = 5201
      to_port     = 5201
      protocol    = "tcp"
      description = "iperf3"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
  egress_rules        = ["all-all"]
  depends_on = [
    module.use1_dev_vpc
  ]
}

module "use1_dev_1_workload" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"
  name = "use1-dev-1-workload"
  ami                    = "ami-08d4ac5b634553e16"
  instance_type          = "t2.micro"
  key_name               = "keypair_name"
  subnet_id              = module.use1_dev_vpc.public_subnets[0]
  vpc_security_group_ids = [module.security_group_useast1dev1_workload.this_security_group_id]
  associate_public_ip_address = true
  user_data_base64       = base64encode(local.use1_dev_1_vm_user_data)
  depends_on = [
    module.use1_dev_vpc
  ]
}

output "use1_dev_1_workload_public_ip" {
  value = module.use1_dev_1_workload.public_ip
}

output "use1_dev_1_workload_private_ip" {
  value = module.use1_dev_1_workload.private_ip
}


locals {
  usw2_prod_1_vm_user_data = <<EOF
#!/bin/bash
sudo hostnamectl set-hostname "usw2-prod-1-vm"
sudo apt update -y
sudo apt upgrade -y
sudo apt-get -y install traceroute unzip build-essential git gcc hping3 apache2 net-tools iperf3
sudo apt autoremove
sudo echo "<html><h1>Aviatrix is awesome from usw2-prod-1</h1></html>" > /var/www/html/index.html 
EOF
}

module "security_group_uswest2prod1_workload" {
  source              = "terraform-aws-modules/security-group/aws"
  version             = "~> 3.0"
  name                = "usw2-prod1-sg"
  description         = "Security group for example usage with EC2 instance"
  vpc_id              = module.usw2_prod_vpc.vpc_id
  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["ssh-tcp", "all-icmp","http-80-tcp"]
  ingress_with_cidr_blocks = [
    {
      from_port   = 5201
      to_port     = 5201
      protocol    = "tcp"
      description = "iperf3"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
  egress_rules        = ["all-all"]
  depends_on = [
    module.usw2_prod_vpc
  ]
  providers = {
    aws = aws.west
   }
}

module "usw2_prod_1_workload" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"
  name = "usw2-prod-1-workload"
  ami                    = "ami-0ddf424f81ddb0720"
  instance_type          = "t2.micro"
  key_name               = "keypair_name"
  subnet_id              = module.usw2_prod_vpc.public_subnets[0]
  vpc_security_group_ids = [module.security_group_uswest2prod1_workload.this_security_group_id]
  associate_public_ip_address = true
  user_data_base64       = base64encode(local.usw2_prod_1_vm_user_data)
  depends_on = [
    module.usw2_prod_vpc
  ]
  providers = {
    aws = aws.west
   }
}

output "usw2_prod_1_workload_public_ip" {
  value = module.usw2_prod_1_workload.public_ip
}

output "usw2_prod_1_workload_private_ip" {
  value = module.usw2_prod_1_workload.private_ip
}

locals {
  usw2_dev_1_vm_user_data = <<EOF
#!/bin/bash
sudo hostnamectl set-hostname "usw2-dev-1-vm"
sudo apt update -y
sudo apt upgrade -y
sudo apt-get -y install traceroute unzip build-essential git gcc hping3 apache2 net-tools iperf3
sudo apt autoremove
sudo echo "<html><h1>Aviatrix is awesome from usw2-dev-1</h1></html>" > /var/www/html/index.html 
EOF
}

module "security_group_uswest2dev1_workload" {
  source              = "terraform-aws-modules/security-group/aws"
  version             = "~> 3.0"
  name                = "usw2-dev1-sg"
  description         = "Security group for example usage with EC2 instance"
  vpc_id              = module.usw2_dev_vpc.vpc_id
  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["ssh-tcp", "all-icmp","http-80-tcp"]
  ingress_with_cidr_blocks = [
    {
      from_port   = 5201
      to_port     = 5201
      protocol    = "tcp"
      description = "iperf3"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
  egress_rules        = ["all-all"]
  depends_on = [
    module.usw2_dev_vpc
  ]
  providers = {
    aws = aws.west
   }
}

module "usw2_dev_1_workload" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"
  name = "usw2-dev-1-workload"
  ami                    = "ami-0ddf424f81ddb0720"
  instance_type          = "t2.micro"
  key_name               = "keypair_name"
  subnet_id              = module.usw2_dev_vpc.public_subnets[0]
  vpc_security_group_ids = [module.security_group_uswest2dev1_workload.this_security_group_id]
  associate_public_ip_address = true
  user_data_base64       = base64encode(local.usw2_dev_1_vm_user_data)
  depends_on = [
    module.usw2_dev_vpc
  ]
  providers = {
    aws = aws.west
   }
}

output "usw2_dev_1_workload_public_ip" {
  value = module.usw2_dev_1_workload.public_ip
}

output "usw2_dev_1_workload_private_ip" {
  value = module.usw2_dev_1_workload.private_ip
}
