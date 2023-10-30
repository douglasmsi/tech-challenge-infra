##########################################################################################
# AWS EKS Output



output "cluster_certificate_authority_data" {
  value = module.cluster.cluster_certificate_authority_data
}



output "cluster_iam_role_arn" {
  value = module.cluster.cluster_iam_role_arn
}

output "cluster_iam_role_name" {
  value = module.cluster.cluster_iam_role_name
}

output "cluster_id" {
  value = module.cluster.cluster_id
}


output "cluster_version" {
  value = module.cluster.cluster_version
}








##########################################################################################
# AWS VPC Output

output "azs" {
  value = module.vpc.azs
}

output "default_vpc_id" {
  value = module.vpc.default_vpc_id
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "vpc_instance_tenancy" {
  value = module.vpc.vpc_instance_tenancy
}

output "vpc_main_route_table_id" {
  value = module.vpc.vpc_main_route_table_id
}

output "igw_id" {
  value = module.vpc.igw_id
}

output "private_subnets" {
  value = module.vpc.private_subnets
}

output "private_subnets_cidr_blocks" {
  value = module.vpc.private_subnets_cidr_blocks
}

output "private_route_table_ids" {
  value = module.vpc.private_route_table_ids
}

output "public_subnets" {
  value = module.vpc.public_subnets
}

output "public_route_table_ids" {
  value = module.vpc.public_route_table_ids
}

##########################################################################################
# AWS RDS Output
output "db_instance_address" {
  value = module.db.this_db_instance_address
}

output "db_instance_arn" {
  value = module.db.this_db_instance_arn
}

output "db_instance_availability_zone" {
  value = module.db.this_db_instance_availability_zone
}

output "db_instance_endpoint" {
  value = module.db.this_db_instance_endpoint
}

output "db_instance_hosted_zone_id" {
  value = module.db.this_db_instance_hosted_zone_id
}

output "db_instance_id" {
  value = module.db.this_db_instance_id
}

output "db_instance_name" {
  value = module.db.this_db_instance_name
}

output "db_instance_port" {
  value = module.db.this_db_instance_port
}

output "db_instance_resource_id" {
  value = module.db.this_db_instance_resource_id
}

output "db_instance_status" {
  value = module.db.this_db_instance_status
}

output "db_instance_username" {
  value = module.db.this_db_instance_username
}

output "db_option_group_arn" {
  value = module.db.this_db_option_group_arn
}

output "db_option_group_id" {
  value = module.db.this_db_option_group_id
}

output "db_parameter_group_arn" {
  value = module.db.this_db_parameter_group_arn
}

output "db_parameter_group_id" {
  value = module.db.this_db_parameter_group_id
}

output "db_subnet_group_arn" {
  value = module.db.this_db_subnet_group_arn
}

output "db_subnet_group_id" {
  value = module.db.this_db_subnet_group_id
}

output "jdbc_url" {
  value = "jdbc:postgresql://${module.db.this_db_instance_endpoint}/${module.db.this_db_instance_name}"
}

output "cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = module.cluster.cluster_endpoint
}

output "cluster_security_group_id" {
  description = "Security group ids attached to the cluster control plane"
  value       = module.cluster.cluster_security_group_id
}

output "region" {
  description = "AWS region"
  value       = var.region
}

output "cluster_name" {
  description = "Kubernetes Cluster Name"
  value       = module.cluster.cluster_name
}
