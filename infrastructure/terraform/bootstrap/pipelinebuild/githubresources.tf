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
  repository      = var.GitHubRepo
  secret_name     = "AWS_ROLE"
  plaintext_value = lookup(local.gha_iam_role, "dev", null)
}

# Terraform state S3 bucket name
resource "github_actions_secret" "TF_STATE_BUCKET_NAME" {
  repository      = var.GitHubRepo
  secret_name     = "TF_STATE_BUCKET_NAME"
  plaintext_value = lookup(local.tfstate_bucket_name, "dev", null)
}

# Terraform state S3 bucket key
resource "github_actions_secret" "TF_STATE_BUCKET_KEY" {
  repository      = var.GitHubRepo
  secret_name     = "TF_STATE_BUCKET_KEY"
  plaintext_value = "terraform/dev.tfstate"
}

# Terraform state locking DynamoDB table
resource "github_actions_secret" "TF_STATE_DYNAMODB_TABLE" {
  repository      = var.GitHubRepo
  secret_name     = "TF_STATE_DYNAMODB_TABLE"
  plaintext_value = lookup(local.tfstate_dynamodb_table, "dev", null)
}

### Create GitHub Variables

# Locals used for constructing GitHub Variables
locals {
  # Declare GitHub Environments variables
  environment_variables_common = {
    # Deployment role
    AWS_ROLE          = lookup(local.gha_iam_role, "dev", null)
    # Deployment region e.g. eu-west-1
    TF_VAR_REGION     = "us-east-1"
    # Deployment Availability Zone 1 e.g. eu-west-1a
    TF_VAR_AZ01       = "us-east-1a"
    # Deployment Availability Zone 2 e.g. eu-west-1b
    TF_VAR_AZ02       = "us-east-1b"
    # The Public IP address from which the web application will be accessed e.g. x.x.x.x/32
    TF_VAR_PUBLICIP   = "10.0.0.1/32"
    # A prefix appended to the name of all AWS-created resources e.g. ghablog WARNING: use lowercase character only and no symbols
    TF_VAR_PREFIX     = "ghablog"
    TF_VAR_SOLTAG     = "AWS-GHA-TF-MSFT"
    TF_VAR_GITHUBREPO = var.GitHubRepo
    # The first two octets of the CIDR IP address range e.g. 10.0
    TF_VAR_VPCCIDR    = "10.0"
    TF_VAR_ECRREPO    = "mswebapp"
    TF_VAR_IMAGETAG   = "1.0.0"
  }
  # Declare dev specific GitHub Environments variables
  environment_variables_dev = merge(
    local.environment_variables_common,
    {
      TF_VAR_ENVCODE = "dv"
      TF_VAR_ENVTAG  = "Development"
    }
  )
}
# Create GitHub Environment Variables
resource "github_actions_variable" "dev" {
  for_each = local.environment_variables_dev

  repository    = var.GitHubRepo
  variable_name = each.key
  value         = each.value
}