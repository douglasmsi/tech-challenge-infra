// Configure AWS VPC, Subnets, and Routes



module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.0.0"

  name = "tech-challenge-vpc"

  azs            = var.azs

  private_subnets =var.private_subnets
  public_subnets = var.public_subnets

  cidr = "10.0.0.0/20"

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  public_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = 1
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = 1
  }

  tags = {
    team = "tech-challenge"
  }
}