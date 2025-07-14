
variable "ami_id" {
  description = "AMI ID for EC2 instances"
  type        = string
}

variable "vpc_cidr" {
  description = "Custom VPC cidr block"
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

variable "vpc_name" {
  description = "VPC name"
  type        = string
}
