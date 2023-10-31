##############################################################
# Data sources to get VPC, subnets and security group details
##############################################################

resource "aws_security_group" "sec_grp_rds" {
  name_prefix = "${var.name}-"
  vpc_id      = module.vpc.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "tech-challenge-sg-rds"
  }
}

resource "aws_subnet" "rds_subnet" {
  vpc_id            = module.vpc.vpc_id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1a"
}

resource "aws_db_instance" "tech-challenge-database" {
  allocated_storage   = 20
  storage_type        = "gp2"
  identifier          = "tech-challenge"
  engine              = "postgres"
  engine_version      = "14"
  instance_class      = "db.t3.micro"
  db_name             = kubernetes_config_map.tech-challenge-config-map.data.postgres-database-name
  username            = kubernetes_config_map.tech-challenge-config-map.data.postgres-user-username
  password            = kubernetes_config_map.tech-challenge-config-map.data.postgres-user-password
  port                = 5432
  publicly_accessible = true
  skip_final_snapshot = true
  vpc_security_group_ids = [aws_security_group.sec_grp_rds.id]
  tags = {
    Name = "tech-challenge-rds"
  }
}