provider "aws" {
  region = "eu-central-1"
}

resource "aws_iam_user" "lb" {
  name = "demoInstance"

  tags = {
    tag-key = "tag-value"
  }
}