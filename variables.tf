variable "name" {
  description = "Name prefix for all resources"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
}

variable "public_subnets" {
  description = "List of public subnet CIDRs"
  type        = list(string)
}

variable "private_subnets" {
  description = "List of private subnet CIDRs"
  type        = list(string)
}

variable "azs" {
  description = "List of availability zones"
  type        = list(string)
}

variable "nat_type" {
  description = "Type of NAT to deploy: nat-gateway or fck-nat"
  type        = string
  validation {
    condition     = contains(["nat-gateway", "fck-nat"], var.nat_type)
    error_message = "nat_type must be either 'nat-gateway' or 'fck-nat'."
  }
}

variable "fck_nat_ami" {
  description = "AMI ID for the FCK-NAT instance"
  type        = string
  default     = null
}

variable "fck_nat_instance_type" {
  description = "Instance type for FCK-NAT instance"
  type        = string
  default     = "t3.micro"
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
