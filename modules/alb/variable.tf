variable "name" {
  description = "Name prefix for ALB and related resources"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where ALB will be deployed"
  type        = string
}

variable "public_subnets" {
  description = "List of public subnet IDs for ALB"
  type        = list(string)
}

variable "alb_sg_id" {
  description = "Security group ID for the ALB"
  type        = string
}

variable "instance_ids" {
  description = "List of EC2 instance IDs to attach to the target group"
  type        = string
}
