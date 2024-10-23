# Create private subnet group
resource "aws_db_subnet_group" "custom" {
  name       = "public-rds-subnet-group"
  subnet_ids = ["subnet-02906b242c3906333", "subnet-05aeeee8147943381" ]

  tags = {
    Name = "My DB subnet group"
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
  db_subnet_group_name = "rds-subnet-group"
}