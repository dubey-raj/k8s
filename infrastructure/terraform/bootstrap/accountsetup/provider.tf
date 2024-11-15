provider "aws" {
  alias   = "primary"
  profile = "iam_admin_raj"
  region  = var.Region
}

provider "aws" {
  alias   = "development"
  profile = "iam_admin_raj"
  region  = var.Region

  default_tags {
    tags = {
      Environment = "Development"
      Provisioner = "Terraform"
      Solution    = "AWS-GHA-TF-MSFT"
    }
  }
}