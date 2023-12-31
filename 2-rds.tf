resource "aws_security_group" "tech-challenge-sg-rds" {
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

resource "aws_db_subnet_group" "tech-challenge-rds-subnet-group" {
  name       = "tech-challenge-rds-subnet-group"
  description = "RDS subnet group for tech-challenge"
  subnet_ids = [
    module.vpc.public_subnets[0],
    module.vpc.public_subnets[1],
    module.vpc.public_subnets[2]
  ]
}

resource "aws_db_instance" "tech-challenge-database" {
  allocated_storage   = 20
  storage_type        = "gp2"
  identifier          = "tech-challenge"
  engine              = "postgres"
  engine_version      = "14"
  instance_class      = "db.t3.micro"
  db_name             = "techchallengedb" #kubernetes_config_map.tech-challenge-config-map.data.postgres-database-name
  username            = "techchallengeuser" #kubernetes_config_map.tech-challenge-config-map.data.postgres-user-username
  password            = "techchallengepassword" #kubernetes_config_map.tech-challenge-config-map.data.postgres-user-password
  port                = 5432
  publicly_accessible = true
  skip_final_snapshot = true
  vpc_security_group_ids = [aws_security_group.tech-challenge-sg-rds.id]
  db_subnet_group_name = aws_db_subnet_group.tech-challenge-rds-subnet-group.name
  tags = {
    Name = "tech-challenge-rds"
  }
}