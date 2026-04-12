# data "azurerm_policy_definition" "require_tag" {
#   display_name = "Require a tag and its value on resources"
# }

# resource "azurerm_resource_group_policy_assignment" "enforce_cost_center" {
#   name                 = "require-cost-center-tag"
#   resource_group_id    = azurerm_resource_group.az104_rg2.id
#   policy_definition_id = data.azurerm_policy_definition.require_tag.id
#   display_name         = "Require Cost Center tag and its value on resources"
#   description          = "Require Cost Center tag and its value on all resources in the resource group"

#   parameters = jsonencode({
#     "tagName" = {
#       "value" = "Cost Center"
#     },
#     "tagValue" = {
#       "value" = "000"
#     }
#   })
# }

# commented out to not conflict with task 3
