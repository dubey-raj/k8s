# Account Settings
variable "Region" {
  description = "AWS deployment region"
  type        = string
}

# Tagging and naming
variable "Prefix" {
  description = "Prefix used to name all resources"
  type        = string
}

variable "GitHubRepos" {
  description = "GitHub repositories name"
  type        = set(string)
}