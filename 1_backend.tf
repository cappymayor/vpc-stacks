terraform {
  backend "s3" {
    bucket = "cde-terraform-state"
    region = "eu-central-1"
    key    = "production/production.tfstate"
  }
}