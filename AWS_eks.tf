// Configure AWS EKS Cluster

module "cluster" {
  version      = "19.15.3"
  source       = "terraform-aws-modules/eks/aws"
  cluster_name = var.name
  subnets      = module.vpc.public_subnets

  tags = var.tags

  vpc_id                 = module.vpc.vpc_id
  cluster_delete_timeout = "60m"
  cluster_create_timeout = "60m"
  manage_aws_auth        = "true"
  write_kubeconfig       = "true"
  config_output_path     = "./"

  eks_managed_node_group_defaults = {
    ami_type = "AL2_x86_64"

  }

  eks_managed_node_groups = {
    one = {
      name = "node-group-1"

      instance_types = ["t3.small"]

      min_size     = 2
      max_size     = 5
      desired_size = 3
    }

    two = {
      name = "node-group-2"

      instance_types = ["t3.small"]

      min_size     = 2
      max_size     = 5
      desired_size = 3
    }
  }

}
