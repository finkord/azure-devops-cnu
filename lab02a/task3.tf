data "azurerm_role_definition" "support_contributor" {
  name = "Support Request Contributor"
}

resource "azurerm_role_definition" "custom_support_request" {
  name        = "Custom Support Request"
  scope       = azurerm_management_group.az104_mg1.id
  description = "A custom contributor role for support requests."

  permissions {
    actions = data.azurerm_role_definition.support_contributor.permissions[0].actions

    not_actions = [
      "Microsoft.Support/register/action"
    ]

    data_actions     = data.azurerm_role_definition.support_contributor.permissions[0].data_actions
    not_data_actions = data.azurerm_role_definition.support_contributor.permissions[0].not_data_actions
  }

  assignable_scopes = [
    azurerm_management_group.az104_mg1.id
  ]
}
