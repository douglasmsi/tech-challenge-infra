// Configure AWS VPC, Subnets, and Routes



module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.0.0"

  name = "tech-challenge-vpc"

  azs            = var.azs

  private_subnets = "10.0.1.0/24"
  public_subnets  = "10.0.3.0/24"

  cidr = "10.0.0.0/16"

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