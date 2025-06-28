terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.95.0"
    }
  }
}


# Default provider for global resources
provider "aws" {
  region = "ap-southeast-1"
}
