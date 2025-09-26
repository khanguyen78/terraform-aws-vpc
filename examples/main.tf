terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source  = "khanguyen78/vpc/aws"
  version = "0.0.5"
  name    = "example-vpc"
  vpc_cidr = "10.0.0.0/16"

  public_subnets     = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2/24", "10.0.3.0/24" ]
  app_subnets    = ["10.0.10.0/24", "10.0.11.0/24", "10.0.12.0/24", "10.0.13.0/24"]
  data_subnets    = ["10.0.20.0/24", "10.0.21.0/24", "10.0.22.0/24", "10.0.23.0/24"]
  #availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d"]
  azs = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d"]
  nat_type = "nat-gateway"
  tags = {
    Environment = "development"
    Name    = "example-vpc"
    Project     = "example"
  }
}
