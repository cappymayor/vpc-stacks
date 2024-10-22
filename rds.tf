resource "aws_db_subnet_group" "custom" {
  name       = "main"
  subnet_ids = [aws_subnet.private-1.id, aws_subnet.private-2.id ]

  tags = {
    Name = "My DB subnet group"
  }
}

resource "aws_db_instance" "default" {
  allocated_storage    = 10
  identifier           = "cde-db"
  db_name              = "cde"
  engine               = "postgres"
  engine_version       = "16"
  instance_class       = "db.t3.micro"
  username             = "foo"
  password             = "foobarbaz"
  skip_final_snapshot  = true
  db_subnet_group_name = aws_db_subnet_group.custom.id
}