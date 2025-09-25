
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
  name    = "example-vpc"
  vpc_cidr = "10.0.0.0/16"

  public_subnets     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24", "10.0.4.0/24" ]
  private_subnets    = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24", "10.0.104.0/24"]
  availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d"]
  tags = {
    Environment = "development"
    Name    = "example-vpc"
    Project     = "example"
  }
}
