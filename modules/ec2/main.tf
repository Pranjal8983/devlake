provider "aws" {
    region = "us-east-1"
}

resource "aws_instance" "ec2"{
    ami = var.ami_id
    instance_type = "t2.medium"
    subnet_id = var.public_subnets[0]
    vpc_security_group_ids = [var.sg_id]
    associate_public_ip_address = true
    user_data = file("${path.module}/userdata-0.sh")
    tags = {
      Name = "Instance-0"
    }
}
