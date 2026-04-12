resource "azurerm_managed_disk" "az104_disk5" {
  name                 = "az104-disk5"
  location             = azurerm_resource_group.az104_rg3.location
  resource_group_name  = azurerm_resource_group.az104_rg3.name
  storage_account_type = "StandardSSD_LRS"
  create_option        = "Empty"
  disk_size_gb         = 32
}
