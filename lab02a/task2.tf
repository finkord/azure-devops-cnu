data "azuread_client_config" "current" {}

resource "azuread_group" "helpdesk" {
  display_name     = "helpdesk"
  owners           = [data.azuread_client_config.current.object_id]
  security_enabled = true
}

data "azurerm_role_definition" "vm_contributor" {
  name = "Virtual Machine Contributor"
}

resource "azurerm_role_assignment" "helpdesk_vm_contributor" {
  scope                = azurerm_management_group.az104_mg1.id
  role_definition_name = data.azurerm_role_definition.vm_contributor.name
  principal_id         = azuread_group.helpdesk.object_id
}
