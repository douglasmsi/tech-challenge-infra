###################CLUSTER VARIABLES##################
variable region {
  default = "us-east-2"
}


variable vpc_subnet {
  default = "172.16.0.0/16"
}

variable azs {
  type    = list(string)
  default = ["us-east-2a", "us-east-2b"]
}

variable public_subnets {
  type    = list(string)
  default = ["172.16.0.0/20", "172.16.16.0/20"]
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
