terraform {
  backend "s3" {
    region          = var.region
    bucket          = "online-boutique-2025"
    key             = "online-boutique-eks/terraform.tfstate"
    use_lockfile    = true
    }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.95.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.3"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.17.0"
    }
  }
}