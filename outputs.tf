# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

output "cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = module.eks.cluster_endpoint
}

output "cluster_security_group_id" {
  description = "Security group ids attached to the cluster control plane"
  value       = module.eks.cluster_security_group_id
}

output "region" {
  description = "AWS region"
  value       = var.region
}

output "cluster_name" {
  description = "Kubernetes Cluster Name"
  value       = module.eks.cluster_name
}

output "private_subnet_ids" {
  value = module.vpc.private_subnets
}

output "public_subnet_ids" {
  value = module.vpc.public_subnets
}

output "postgres_host_client" {
  value = aws_db_instance.tech-challenge-client-database.address
}

output "postgres_host_order" {
  value = aws_db_instance.tech-challenge-order-database.address
}

output "postgres_host_payment" {
  value = aws_db_instance.tech-challenge-payment-database.address
}

output "postgres_host_hackaton" {
  value = aws_db_instance.tech-challenge-hackaton-database.address
}