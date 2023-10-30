##############################################################
# Data sources to get VPC, subnets and security group details
##############################################################

resource "aws_security_group" "sec_grp_rds" {
  name_prefix = "${module.cluster.cluster_id}-"
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

  tags = var.tags
}

resource "aws_db_instance" "tech-challenge-database" {
  allocated_storage   = 20
  storage_type        = "gp2"
  identifier          = "tech-challenge"
  engine              = "postgres"
  engine_version      = "14"
  instance_class      = "db.t3.micro"
  db_name             = "tech-challenge-database"
  username            = "fastfooduser"
  password            = "fastfoodpass"
  port                = 5432
  publicly_accessible = true
  skip_final_snapshot = true
  subnet_ids = module.vpc.public_subnets
  vpc_security_group_ids = [aws_security_group.sec_grp_rds.id]
  tags = {
    Name = "tech-challenge-rds"
  }
}