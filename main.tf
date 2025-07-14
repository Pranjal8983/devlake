resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
 
}

resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"
 
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
 
}

resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}
resource "aws_security_group" "security_group" {
  name        = "uc1-sg"
  description = "Allow HTTP traffic only from ALB"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

   ingress {
    from_port   = 4000
    to_port     = 4000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "alb_security_group" {
  name        = "uc1-alb-sg"
  description = "Allow HTTP traffic only from ALB"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

provider "aws" {
    region = "us-east-1"
}

resource "aws_instance" "ec2"{
    ami = ami-0150ccaf51ab55a51
    instance_type = "t2.medium"
    subnet_id = aws_subnet.public.id
    vpc_security_group_ids = aws_security_group.security_group.id
    associate_public_ip_address = true
    user_data = file("${path.module}/userdata-0.sh")
    tags = {
      Name = "Instance-0"
    }
}
resource "aws_lb" "this" {
  name               = newalb
  internal           = false
  load_balancer_type = "application"
  security_groups    = aws_security_group.security_group.id
  subnets            = aws_subnet.public.id

 
}

# Target Groups
resource "aws_lb_target_group" "default" {
  name     = "new-tg-default"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
}

# Listener
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.default.arn
  }
}


resource "aws_lb_target_group_attachment" "default" {
  target_group_arn = aws_lb_target_group.default.arn
  target_id        = aws_instance.ec2.id
  port             = 4000
}
