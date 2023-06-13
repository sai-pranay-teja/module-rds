resource "aws_rds_cluster" "rds" {
  cluster_identifier      = "${var.env}-rds-roboshop"
  engine                  = var.engine
  engine_version          = var.engine_version
  database_name           = var.database_name
  master_username         = "foo"
  master_password         = "bar"
  backup_retention_period = var.backup_retention_period
  preferred_backup_window = var.preferred_backup_window
  db_subnet_group_name=aws_db_subnet_group.rds-subnet.name
  skip_final_snapshot=var.skip_final_snapshot
  vpc_security_group_ids=[aws_security_group.rds-sg.id]
}

resource "aws_rds_cluster_instance" "cluster_instances" {
  count              = var.no_of_instances
  identifier         = "${var.env}-rds-cluster-roboshop-${count.index}"
  cluster_identifier = aws_rds_cluster.rds.id
  instance_class     = var.instance_class
  engine             = aws_rds_cluster.rds.engine
  engine_version     = aws_rds_cluster.rds.engine_version
}

resource "aws_security_group" "rds-sg" {
  name        = "${var.env}-roboshop-rds-SG"
  description = "Security groups for rds"
  vpc_id      = var.vpc_id

  ingress {
    description      = "TLS from VPC"
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    cidr_blocks      = var.allow_subnets

  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "${var.env}-roboshop-rds-SG"
  }
}

resource "aws_db_subnet_group" "rds-subnet" {
  name       = "${var.env}-rds-subnet"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "${var.env} rds subnet group"
  }
}