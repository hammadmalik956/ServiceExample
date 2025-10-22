terraform {
  required_version = ">= 1.8"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=5.51.0"
    }
  }
}


provider "aws" {
  region = "us-east-2"
  default_tags {
    tags = {
      SemanticVersion = var.semantic_version
    }
  }
}