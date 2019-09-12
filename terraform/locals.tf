locals {
  availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]
  private_cidrs      = ["10.0.16.0/24", "10.0.17.0/24", "10.0.18.0/24"]
  public_cidrs       = ["10.0.32.0/24", "10.0.33.0/24", "10.0.34.0/24"]
}
