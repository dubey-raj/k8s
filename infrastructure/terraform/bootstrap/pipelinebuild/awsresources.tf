### Create AWS resources for Terraform bootstrapping across multiple accounts
module "tfbootstrap_dev" {
  source = "./modules/tfbootstrap"
  providers = {
    aws = aws.development
  }
  Region     = var.Region
  Prefix     = var.Prefix
  GitHubRepos = var.GitHubRepos
}