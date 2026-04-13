# 
resource "azurerm_virtual_network" "mfg_vnet" {
  name                = "ManufacturingVnet"
  address_space       = ["10.30.0.0/16"]
  location            = azurerm_resource_group.az104_rg4.location
  resource_group_name = azurerm_resource_group.az104_rg4.name

  subnet {
    name             = "SensorSubnet1"
    address_prefixes = ["10.30.20.0/24"]
  }

  subnet {
    name             = "SensorSubnet2"
    address_prefixes = ["10.30.21.0/24"]
  }
}
