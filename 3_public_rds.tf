# Create public subnet group to be attached to the RDS instance 
resource "aws_db_subnet_group" "public_custom_subnet_group" {
  name       = "public-rds-subnet-group"
  subnet_ids = [aws_subnet.public_1.id, aws_subnet.public_2.id]

  tags = {
    Name = "public subnet group"
  }
}

# Security group to be attached to the RDS instance deployed in public subnet
resource "aws_security_group" "postgres_connection" {
  name        = "rds_connection_sg"
  description = "Allow inbound and Outbound traffic to RDS instances"
  vpc_id      = aws_vpc.custom.id

  tags = {
    Name = "Postgres_sg"
  }
}


# Rule to allow inbound traffic
resource "aws_vpc_security_group_ingress_rule" "postgres_inbound_connection" {
  security_group_id = aws_security_group.postgres_connection.id
  cidr_ipv4         = "0.0.0.0/0" # Any IP address, Please restrict this in production 
  from_port         = 5432
  ip_protocol       = "tcp"
  to_port           = 5432
}


# Rule to allow outbound traffic
resource "aws_vpc_security_group_egress_rule" "postgres_outbound_connection" {
  security_group_id = aws_security_group.postgres_connection.id
  cidr_ipv4         = "0.0.0.0/0" # Any IP address
  ip_protocol       = "-1"        #equivalent to all ports
}


# RDS instance creation
resource "aws_db_instance" "default" {
  allocated_storage     = 10
  max_allocated_storage = 100
  identifier            = "demo-db-instance"
  db_name               = "cde"
  engine                = "postgres"
  engine_version        = "16"
  instance_class        = "db.t3.micro"
  username              = "foo" # Do not hardcode in Production, manage this with ssm params
  password              = "foobarbaz"  # Do not hardcode in Production, manage this with ssm params
  publicly_accessible   = true
  vpc_security_group_ids = [aws_security_group.postgres_connection.id]
  skip_final_snapshot   = true
  db_subnet_group_name  = aws_db_subnet_group.public_custom_subnet_group.id  # deployoimng pj
}