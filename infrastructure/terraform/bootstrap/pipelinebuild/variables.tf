# Regions
variable "Region" {
  description = "AWS deployment region"
  type        = string
}

# Tagging and naming
variable "Prefix" {
  description = "Prefix used to name all resources"
  type        = string
}

# Assumed Role ARNs
variable "dev_role_arn" {
  description = "Dev environment deployment role created in bootstrap/accountsetup"
  type        = string
}

variable "GitHubRepos" {
  description = "GitHub repository name"
  type        = set(string)
}