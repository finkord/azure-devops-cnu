
data "azurerm_policy_definition" "inherit_tag" {
  display_name = "Inherit a tag from the resource group if missing"
}

resource "azurerm_resource_group_policy_assignment" "inherit_cost_center" {
  name                 = "inherit-cost-center"
  resource_group_id    = azurerm_resource_group.az104_rg2.id
  policy_definition_id = data.azurerm_policy_definition.inherit_tag.id
  display_name         = "Inherit the Cost Center tag and its value 000 from the resource group if missing"
  location             = azurerm_resource_group.az104_rg2.location

  identity {
    type = "SystemAssigned"
  }

  parameters = jsonencode({
    "tagName" = {
      "value" = "Cost Center"
    }
  })
}

resource "azurerm_role_assignment" "policy_remediation_role" {
  scope                = azurerm_resource_group.az104_rg2.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_resource_group_policy_assignment.inherit_cost_center.identity[0].principal_id
}

resource "azurerm_resource_group_policy_remediation" "remediate_cost_center" {
  name                 = "remediate-cost-center-tags"
  resource_group_id    = azurerm_resource_group.az104_rg2.id
  policy_assignment_id = azurerm_resource_group_policy_assignment.inherit_cost_center.id
}
