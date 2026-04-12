

# resource "azurerm_management_lock" "rg_lock" {
#   name       = "rg-lock"
#   scope      = azurerm_resource_group.az104_rg2.id
#   lock_level = "CanNotDelete"
#   notes      = "This lock prevents accidental deletion of the resource group"
# }
