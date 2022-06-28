provider "aviatrix" {
  username                = "replace_me"
  password                = var.password
  controller_ip           = var.controller2_ip
  skip_version_validation = false
}

provider "aws" {
  region = "us-east-1"
  access_key = "replace_me"
  secret_key = "replace_me"
}

provider "aws" {
  alias = "west"
  region = "us-west-2"
  access_key = "replace_me"
  secret_key = "replace_me"
}
