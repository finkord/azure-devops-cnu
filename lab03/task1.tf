
terraform {
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.0"
    }
  }
}

data "azuread_domains" "default" {
  only_initial = true
}

output "domain_names" {
  value = data.azuread_domains.default.domains[0].domain_name
}


