terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.0.0"
    }
  }
}

provider "github" {
  owner = "dubey-raj"
  token = "<github-pat-token>"
}

provider "aws" {
  alias   = "development"
  profile = "iam_admin_raj"
  region  = var.Region

  assume_role {

    role_arn = var.dev_role_arn
  }
  default_tags {
    tags = {
      Environment = "Development"
      Provisioner = "Terraform"
      Solution    = "AWS-GHA-TF-MSFT"
    }
  }
}