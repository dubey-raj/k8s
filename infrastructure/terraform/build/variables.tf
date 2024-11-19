# Regions
variable "Region" {
  description = "AWS depoloyment region"
  type        = string
}
variable "AZ01" {
  description = "Availability Zone 1"
  type        = string
}
variable "AZ02" {
  description = "Availability Zone 2"
  type        = string
}
# Tagging and naming
variable "SolTag" {
  description = "Solution tag value. All resources are created with a 'Solution' tag name and the value you set here"
  type        = string
}

# Networking
variable "VPCCIDR" {
  description = "VPC CIDR range"
  type        = string
}
variable "PublicIP" {
  description = "Limits application access to a specified public IP address"
  type        = string
  default = "0.0.0.0/0"
}