### Create AWS resources for Terraform bootstrapping across multiple accounts
module "tfbootstrap_dev" {
  source = "./modules/tfbootstrap"
  providers = {
    aws = aws.development
  }
  Region     = var.Region
  Prefix     = var.Prefix
  GitHubRepo = var.GitHubRepo
}

# DEBUGGING: Outputs for GitHub Action Secrets
# output "gha_iam_role" {
#   value = {
#     dev  = module.tfbootstrap_dev.gha_iam_role
#   }
# }

# output "tfstate_bucket_names" {
#   value = {
#     dev  = module.tfbootstrap_dev.tfstate_bucket_name
#   }
# }

# output "tfstate_dynamodb_table" {
#   value = {
#     dev  = module.tfbootstrap_dev.tfstate_dynamodb_table_name
#   }
# }