variable "ami_id" {
  description = "AMI ID for EC2 instances"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "sg_id" {
  description = "Security group ID"
  type = string
}

variable "public_subnets" {
  description = "Public subnet ID's "
  type = list(any)
}
