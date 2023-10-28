# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

provider "aws" {
  region = var.region
}

# Filter out local zones, which are not currently supported
# with managed node groups
data "aws_availability_zones" "available" {
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

locals {
 # cluster_name = "tech-challenge-eks-${random_string.suffix.result}"
  cluster_name = "tech-challenge-eks"
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
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.15.3"

  cluster_name    = local.cluster_name
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

      instance_types = ["t2.micro"]

      min_size     = 1
      max_size     = 3
      desired_size = 2
    }

    two = {
      name = "node-group-2"

      instance_types = ["t2.micro"]

      min_size     = 1
      max_size     = 2
      desired_size = 1
    }
  }
}


# https://aws.amazon.com/blogs/containers/amazon-ebs-csi-driver-is-now-generally-available-in-amazon-eks-add-ons/
data "aws_iam_policy" "ebs_csi_policy" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}

module "irsa-ebs-csi" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version = "4.7.0"

  create_role                   = true
  role_name                     = "AmazonEKSTFEBSCSIRole-${module.eks.cluster_name}"
  provider_url                  = module.eks.oidc_provider
  role_policy_arns              = [data.aws_iam_policy.ebs_csi_policy.arn]
  oidc_fully_qualified_subjects = ["system:serviceaccount:kube-system:ebs-csi-controller-sa"]
}

resource "aws_eks_addon" "ebs-csi" {
  cluster_name             = module.eks.cluster_name
  addon_name               = "aws-ebs-csi-driver"
  addon_version            = "v1.20.0-eksbuild.1"
  service_account_role_arn = module.irsa-ebs-csi.iam_role_arn
  tags = {
    "eks_addon" = "ebs-csi"
    "terraform" = "true"
  }
}

provider "kubernetes" {
  config_context_cluster = "module.eks.kubeconfig"
}

# Defina o recurso do namespace "fast-food"
resource "kubernetes_namespace" "fast_food" {
  metadata {
    name = "fast-food"
  }
}

# Defina o recurso do Service "fast-food-service"
resource "kubernetes_service" "fast_food_service" {
  metadata {
    name = "fast-food-service"
    labels = {
      app = "fast-food-pod"
    }
  }

  spec {
    type = "LoadBalancer"

    selector = {
      app = "fast-food-pod"
    }

    port {
      port        = 80
      target_port = 8080
      protocol    = "TCP"
    }
  }
}

# Defina os recursos de métricas
resource "kubernetes_service_account" "metrics_server_service_account" {
  metadata {
    name = "metrics-server"
    namespace = "kube-system"
    labels = {
      k8s-app = "metrics-server"
    }
  }
}

resource "kubernetes_cluster_role" "aggregated_metrics_reader" {
  metadata {
    name = "system:aggregated-metrics-reader"
    labels = {
      k8s-app = "metrics-server"
      rbac.authorization.k8s.io/aggregate-to-admin = "true"
      rbac.authorization.k8s.io/aggregate-to-edit  = "true"
      rbac.authorization.k8s.io/aggregate-to-view  = "true"
    }
  }

  rule {
    api_groups = ["metrics.k8s.io"]
    resources  = ["pods", "nodes"]
    verbs      = ["get", "list", "watch"]
  }
}

resource "kubernetes_deployment" "fast_food_deployment" {
  metadata {
    name      = "fast-food-pod"
    namespace = "fast-food"
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = "fast-food-pod"
      }
    }

    template {
      metadata {
        labels = {
          app = "fast-food-pod"
        }
      }

      spec {
        container {
          name  = "fastfood"
          image = "653185900972.dkr.ecr.us-east-1.amazonaws.com/tech-challenge:latest"
          image_pull_secret = ["ecr-registry"]


          port {
            container_port = 8080
          }

          liveness_probe {
            http_get {
              path = "/actuator/health"
              port = 8080
            }
            initial_delay_seconds = 10
            period_seconds       = 30
          }

          env_from {
            secret_ref {
              name = "fastfood-security"
            }
            config_map_ref {
              name = "db-secret-credentials"
            }
          }
        }
      }
    }
  }
}
