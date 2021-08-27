terraform {
  required_version = ">= 1.0"
  required_providers {
    aws   = "~> 2.58"
    local = "~> 1.4"
    tls   = "~> 2.1"
  }
}

provider "aws" {
  region = var.region
}
