terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  required_version = ">= 1.5.0"
}

provider "aws" {
  region = "ap-south-1"
}

resource "aws_s3_bucket" "cloudops_demo" {
  bucket = "cloudops-terraform-demo-2026-ichar"

  tags = {
    Name        = "CloudOps Terraform Demo"
    Environment = "Learning"
    ManagedBy   = "Terraform"
  }
}
