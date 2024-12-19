# Terraform Root module/ Parent module

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

variable "region_main" {
  default = "us-east-1"
}

provider "aws" {
  profile = "default"
  region  = var.region_main
}

module "Network_VPC" {
  source = "./module/Network_VPC"
  region = var.region_main
}

module "Database" {
  source      = "./module/Database"
  region      = var.region_main
  vpc_id_main = module.Network_VPC.main_vpc_id
  ec2sg       = module.Network_VPC.internal_sg_id
  privatesub1 = module.Network_VPC.private_subnet_1
  privatesub2 = module.Network_VPC.private_subnet_2
}

module "WebServer" {
  source            = "./module/WebServer"
  region            = var.region_main
  vpc_id_main       = module.Network_VPC.main_vpc_id
  publicsub1        = module.Network_VPC.public_subnet_1
  publicsub2        = module.Network_VPC.public_subnet_2
  albsg             = module.Network_VPC.external_sg_id
  ec2sg             = module.Network_VPC.internal_sg_id
  DB_USER           = module.Database.Username
  DB_PASSWORD_PARAM = module.Database.Password
  DB_HOST           = module.Database.Host
  DB_NAME           = module.Database.dbname
  DB_PORT           = module.Database.Port
}

module "Monitoring" {
  source      = "./module/Monitoring"
  region      = var.region_main
  asg_name    = module.WebServer.ASG_Name
  db_identity = module.Database.Identifier
}