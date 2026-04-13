resource "azurerm_application_security_group" "asg_web" {
  name                = "asg-web"
  location            = azurerm_resource_group.az104_rg4.location
  resource_group_name = azurerm_resource_group.az104_rg4.name
}

resource "azurerm_network_security_group" "nsg_secure" {
  name                = "myNSGSecure"
  location            = azurerm_resource_group.az104_rg4.location
  resource_group_name = azurerm_resource_group.az104_rg4.name

  security_rule {
    name                                  = "AllowASG"
    priority                              = 100
    direction                             = "Inbound"
    access                                = "Allow"
    protocol                              = "Tcp"
    source_port_range                     = "*"
    destination_port_ranges               = ["80", "443"]
    source_application_security_group_ids = [azurerm_application_security_group.asg_web.id]
    destination_address_prefix            = "*"
  }

  security_rule {
    name                       = "DenyInternetOutbound"
    priority                   = 4096
    direction                  = "Outbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "Internet"
  }
}


resource "azurerm_subnet_network_security_group_association" "nsg_assoc" {
  subnet_id                 = azurerm_virtual_network.core_vnet.subnet.*.id[0]
  network_security_group_id = azurerm_network_security_group.nsg_secure.id
}
