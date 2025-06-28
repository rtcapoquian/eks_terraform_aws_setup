# Data Sources
# All data sources used across the infrastructure

data "aws_availability_zones" "available" {
  state = "available"
  #opt-in status filter it out the local zones
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

data "aws_caller_identity" "current" {}

data "aws_partition" "current" {}
