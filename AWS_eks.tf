// Configure AWS EKS Cluster

provider "aws" {
  region = var.region
}

resource "kubernetes_namespace" "tech-challenge-namespace" {
  metadata {
    annotations = {
      name = "tech-challenge-annotation"
    }

    labels = {
      tech-challenge = "tech-challenge"
    }

    name = "tech-challenge-namespace"
  }
}

module "cluster" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.15.3"

  cluster_name    = var.cluster_name
  cluster_version = "1.28"

  vpc_id                         = module.vpc.vpc_id
  subnet_ids                     = module.vpc.private_subnets
  cluster_endpoint_public_access = true

  eks_managed_node_group_defaults = {
    ami_type = "AL2_x86_64"

  }

  eks_managed_node_groups = {
    one = {
      name = "node-group-1"

      instance_types = ["t3.small"]

      min_size     = 1
      max_size     = 4
      desired_size = 2
    }

    two = {
      name = "node-group-2"

      instance_types = ["t3.small"]

      min_size     = 1
      max_size     = 4
      desired_size = 2
    }
  }
}
