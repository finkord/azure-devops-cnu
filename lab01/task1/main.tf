
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

resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

# Create a new user
resource "azuread_user" "local_user" {
  user_principal_name = "az104-user1@${data.azuread_domains.default.domains[0].domain_name}"
  display_name        = "az104-user1"
  password            = random_password.password.result

  account_enabled = true

  job_title      = "IT Lab Administrator"
  department     = "IT"
  usage_location = "US"
}

# Create a new invitation
resource "azuread_invitation" "external_invite" {
  user_display_name  = "Volodymyr"
  user_email_address = "volodymyr.fufalko.23@pnu.edu.ua"
  redirect_url       = "https://myapplications.microsoft.com/?tenantid=3c9ba863-6ab9-4fe9-8883-621b7618203d"

  message {
    body = "Welcome to Azure and our group project!"
  }
}

# resource "azuread_user" "external_user" {
#   user_principal_name = "volodymyr.fufalko.23_pnu.edu.ua#EXT#@devfinkordgmail.onmicrosoft.com"
#   display_name        = "Volodymyr"

#   job_title      = "IT Lab Administrator"
#   department     = "IT"
#   usage_location = "US"
# }

output "local_user_password" {
  value     = random_password.password.result
  sensitive = true
}

output "domain_names" {
  value = data.azuread_domains.default.domains[0].domain_name
}
