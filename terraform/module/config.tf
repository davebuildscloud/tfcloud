provider "aws" {
  region  = "us-east-1"
  version = "~> 2.0"
  profile = "default"
#  version = "2.7.0"
}

terraform {
  required_version = "0.12.8"
}
