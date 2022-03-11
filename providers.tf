terraform {
  required_version = ">= 1.0"
  required_providers {
    aws   = "~> 3.74"
    local = "~> 1.4"
    tls   = "~> 2.1"
  }
}

provider "aws" {
  region = var.region
}
