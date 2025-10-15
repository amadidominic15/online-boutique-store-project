terraform {
  backend "s3" {
    region          = var.region
    bucket          = "online-boutique-2025"
    key             = "githuboidc/terraform.tfstate"
    use_lockfile    = true
    }
  
  required_version = ">= 1.11.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = var.region
}