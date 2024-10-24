# Create private subnet group
resource "aws_db_subnet_group" "private_custom_subnet_group" {
  name       = "public-rds-subnet-group"
  subnet_ids = [aws_subnet.private_1, aws_subnet.private_2]

  tags = {
    Name = "private subnet group"
  }
}

# Create an RDS instance for internal use within VPC 
resource "aws_db_instance" "default" {
  allocated_storage    = 10
  identifier           = "cde-db"
  db_name              = "cde"
  engine               = "postgres"
  engine_version       = "16"
  instance_class       = "db.t3.micro"
  username             = "foo"
  password             = "foobarbaz"
  publicly_accessible = true
  skip_final_snapshot  = true
  db_subnet_group_name = aws_db_subnet_group.private_custom_subnet_group.id
}