###################CLUSTER VARIABLES##################
variable region {
  default = "us-east-1"
}


variable vpc_subnet {
  default = "172.16.0.0/16"
}

variable azs {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b"]
}

variable public_subnets {
  type    = list(string)
  default = ["172.16.0.0/20", "172.16.16.0/20"]
}

variable private_subnets {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable tags {
  type = map(string)

  default = {
    "Environment" = "Development"
  }
}

variable name {
  default = "tech-challenge"
}

variable cluster_name {
  default = "tech-challenge-eks"
}


###################RDS VARIABLES##################
variable "rds_name" {
  default = "dev"
}

variable "rds_port" {
  default = "5432"
}

variable "rds_storage_type" {
  default = "gp2"
}

variable "rds_allocated_storage" {
  default = "50"
}

variable "rds_engine" {
  default = "postgres"
}

variable "rds_engine_version" {
  default = "9.6.10"
}

variable "rds_instance_class" {
  default = "db.m4.xlarge"
}

variable "rds_username" {
  default = "postgres"
}

variable "rds_password" {
  default = "postgres"
}

variable "rds_parameter_group_family" {
  default = "postgres9.6"
}

variable "enable_dashboard" {
  default = true
}
