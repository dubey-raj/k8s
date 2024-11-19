### Create GitHub pipeline resources

# Local variables used to define GitHub Environments and Secrets configuration
locals {
  gha_environment = ["dev"]

  gha_iam_role = {
    dev  = module.tfbootstrap_dev.gha_iam_role
  }
  tfstate_bucket_name = {
    dev  = module.tfbootstrap_dev.tfstate_bucket_name
  }
  tfstate_dynamodb_table = {
    dev  = module.tfbootstrap_dev.tfstate_dynamodb_table_name
  }
}

### Create GitHub Secrets
# IAM Role ARN used by GitHub Actions runner to deploy AWS resources
resource "github_actions_secret" "AWS_ROLE" {
  for_each = var.GitHubRepos

  repository      = each.value
  secret_name     = "AWS_ROLE"
  plaintext_value = lookup(local.gha_iam_role, "dev", null)
}

# Terraform state S3 bucket name
resource "github_actions_secret" "TF_STATE_BUCKET_NAME" {
  for_each = var.GitHubRepos

  repository      = each.value
  secret_name     = "TF_STATE_BUCKET_NAME"
  plaintext_value = lookup(local.tfstate_bucket_name, "dev", null)
}

# Terraform state locking DynamoDB table
resource "github_actions_secret" "TF_STATE_DYNAMODB_TABLE" {
  for_each = var.GitHubRepos

  repository      = each.value
  secret_name     = "TF_STATE_DYNAMODB_TABLE"
  plaintext_value = lookup(local.tfstate_dynamodb_table, "dev", null)
}