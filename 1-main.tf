
provider "aws" {
  region = var.region
}


data "aws_availability_zones" "available" {
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.15.3"

  cluster_name    = var.cluster_name
  cluster_version = "1.28"

  vpc_id                         = module.vpc.vpc_id
  subnet_ids                     = module.vpc.private_subnets
  cluster_endpoint_public_access = true

  eks_managed_node_group_defaults = {
    ami_type = "AL2_x86_64"

    security_group_rules = [
      {
        type        = "ingress"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      },
    ]

  }



  eks_managed_node_groups = {
    one = {
      name = "node-group-1"

      instance_types = ["t3.small"]
      capacity_type  = "SPOT"

      min_size     = 3
      max_size     = 5
      desired_size = 3
    }

    two = {
      name = "node-group-2"

      instance_types = ["t3.small"]
      capacity_type  = "SPOT"

      min_size     = 3
      max_size     = 5
      desired_size = 3
    }
  }


}

locals {
  cluster_name = var.cluster_name
}

resource "random_string" "suffix" {
  length  = 8
  special = false
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.0.0"

  name = "tech-challenge-vpc"

  cidr = "10.0.0.0/16"
  azs  = slice(data.aws_availability_zones.available.names, 0, 3)

  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = 1
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = 1
  }

  tags = {
    team = "tech-challenge"
  }
}

resource "aws_internet_gateway" "tech-challenge-igw" {
  vpc_id = module.vpc.vpc_id

  tags = {
    Name = "tech-challenge-igw"
  }
}

resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name = "tech-challenge-nat"
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = module.vpc.public_subnets[0]
  tags = {
    Name = "tech-challenge-nat"
  }

  depends_on = [aws_internet_gateway.tech-challenge-igw]
}

resource "aws_route_table" "tech-challenge-private" {
  vpc_id = module.vpc.vpc_id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "private"
  }
}

resource "aws_route_table" "tech-challenge-public" {
  vpc_id = module.vpc.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.tech-challenge-igw.id
  }

  tags = {
    Name = "public"
  }
}

resource "aws_route_table_association" "tech-challenge-private-us-east-1-1" {
  subnet_id      = module.vpc.private_subnets[0]
  route_table_id = aws_route_table.tech-challenge-private.id
}

resource "aws_route_table_association" "tech-challenge-private-us-east-1-2" {
  subnet_id      = module.vpc.private_subnets[1]
  route_table_id = aws_route_table.tech-challenge-private.id
}

resource "aws_route_table_association" "tech-challenge-private-us-east-1-3" {
  subnet_id      = module.vpc.private_subnets[2]
  route_table_id = aws_route_table.tech-challenge-private.id
}

resource "aws_route_table_association" "tech-challenge-public-us-east-1-1" {
  subnet_id      = module.vpc.public_subnets[0]
  route_table_id = aws_route_table.tech-challenge-public.id
}

resource "aws_route_table_association" "tech-challenge-public-us-east-1-2" {
  subnet_id      = module.vpc.public_subnets[1]
  route_table_id = aws_route_table.tech-challenge-public.id
}

resource "aws_route_table_association" "tech-challenge-public-us-east-1-3" {
  subnet_id      = module.vpc.public_subnets[2]
  route_table_id = aws_route_table.tech-challenge-public.id
}


data "aws_eks_cluster_auth" "tech-challenge" {
  name = var.name
}





