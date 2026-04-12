resource "azurerm_managed_disk" "az104_disk3" {
  name                 = "az104-disk3"
  location             = azurerm_resource_group.az104_rg3.location
  resource_group_name  = azurerm_resource_group.az104_rg3.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = 32
}
