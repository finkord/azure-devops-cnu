
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

data "azuread_client_config" "current" {}

data "azuread_user" "user1" {
  user_principal_name = "az104-user1@${data.azuread_domains.default.domains[0].domain_name}"
}

data "azuread_user" "guest_user" {
  user_principal_name = "volodymyr.fufalko.23_pnu.edu.ua#EXT#@${data.azuread_domains.default.domains[0].domain_name}"
}

# Create the Security Group
resource "azuread_group" "it_lab_admins" {
  display_name       = "IT Lab Administrators"
  description        = "Administrators that manage the IT lab"
  security_enabled   = true
  assignable_to_role = false

  # Static membership type
  types = []

  owners = [data.azuread_client_config.current.object_id]
}

resource "azuread_group_member" "member_user1" {
  group_object_id  = azuread_group.it_lab_admins.object_id
  member_object_id = data.azuread_user.user1.object_id
}

resource "azuread_group_member" "member_guest" {
  group_object_id  = azuread_group.it_lab_admins.object_id
  member_object_id = data.azuread_user.guest_user.object_id
}
