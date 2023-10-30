###################CLUSTER VARIABLES##################
variable region {
  default = "us-east-2"
}

variable aws_access_key_id {}

variable aws_secret_access_key {}

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

variable "worker_groups" {
  type = list(object({
    instance_type        = string
    asg_desired_capacity = string
    asg_min_size         = string
    asg_max_size         = string
    key_name             = string
  }))

  default = [
    {
      instance_type        = "m4.xlarge"
      asg_desired_capacity = "5"
      asg_min_size         = "5"
      asg_max_size         = "7"
      key_name             = "subhakarkotta"
    }
  ]
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
