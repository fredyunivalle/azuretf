variable "env" {
  description = "Environment tag, such as 'dev', 'prod', etc."
  type = map(string)
  default = {
    prod = "prod",
    dev = "dev",
  }
}

locals {
    region = "East US"
    default_tags = {
     app_tag = "azure-monitoring"
     manager = "Juan Sebastian Martinez"
     environment = var.env[terraform.workspace] == "prod" ? "prod":"dev"
  }
 
}