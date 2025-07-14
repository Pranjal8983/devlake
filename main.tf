module "ec2" {
  source         = "./modules/ec2"
  ami_id         = var.ami_id
  vpc_id         = module.vpc.vpc_id
  sg_id          = module.security_group.sg_id
  public_subnets = module.vpc.public_subnet_ids
}

module "vpc" {
  source          = "./modules/vpc"
  vpc_name        = var.vpc_name
  vpc_cidr        = var.vpc_cidr
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
  azs             = var.azs
}


module "security_group" {
  source = "./modules/security-group"
  vpc_id = module.vpc.vpc_id
}

module "alb" {
  source         = "./modules/alb"
  name           = "myapp-alb"
  vpc_id         = module.vpc.vpc_id
  public_subnets = module.vpc.public_subnet_ids
  alb_sg_id      = module.security_group.alb_sg_id
  instance_ids   = module.ec2.instance_ids
}
