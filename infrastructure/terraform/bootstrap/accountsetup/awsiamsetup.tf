### Create IAM policies required to bootstrap Terraform across multiple accounts
data "aws_caller_identity" "primary" {
  provider = aws.primary
}

data "aws_caller_identity" "development" {
  provider = aws.development
}

module "assumerole_dev" {
  source = "./modules/assumerole"
  providers = {
    aws = aws.development
  }
  Region        = var.Region
  Prefix        = var.Prefix
  Environment   = "dv"
  PrimaryAccount = data.aws_caller_identity.primary.arn
  TargetAccount = data.aws_caller_identity.development.account_id
}

output "role_arn" {
  value = {
    dev_role_arn  = module.assumerole_dev.role_arn
  }
}