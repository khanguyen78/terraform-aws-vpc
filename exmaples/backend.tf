terraform {
  backend "s3" {
    bucket         = "ctac-sateam-sandbox"
    key            = "bnguyen/vpc/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock-table"
  }
}

