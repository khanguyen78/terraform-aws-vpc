# terraform-aws-vpc



```
terraform-vpc-module/
├── main.tf
├── variables.tf
├── outputs.tf
├── README.md

```

# Terraform AWS VPC Module

This module creates the following AWS infrastructure:

- VPC
- Internet Gateway
- NAT Gateway
- Public and Private Subnets
- Route Tables and Associations

## Inputs

| Variable | Description | Type | Required |
|----------|-------------|------|----------|
| `name` | Name prefix | `string` | ✅ |
| `vpc_cidr` | CIDR block for VPC | `string` | ✅ |
| `public_subnets` | List of public subnet CIDRs | `list(string)` | ✅ |
| `private_subnets` | List of private subnet CIDRs | `list(string)` | ✅ |
| `availability_zones` | List of AZs | `list(string)` | ✅ |
| `tags` | Tags to apply | `map(string)` | ❌ |

## Outputs

- `vpc_id`
- `public_subnets`
- `private_subnets`
- `nat_gateway_id`

