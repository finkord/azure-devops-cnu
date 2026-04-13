resource "azurerm_dns_zone" "public" {
  name                = "contoso-volodymyrf.com"
  resource_group_name = azurerm_resource_group.az104_rg4.name
}

resource "azurerm_dns_a_record" "www" {
  name                = "www"
  zone_name           = azurerm_dns_zone.public.name
  resource_group_name = azurerm_resource_group.az104_rg4.name
  ttl                 = 3600
  records             = ["10.1.1.4"]
}

resource "azurerm_private_dns_zone" "private" {
  name                = "private.contoso.com"
  resource_group_name = azurerm_resource_group.az104_rg4.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "mfg_link" {
  name                  = "manufacturing-link"
  resource_group_name   = azurerm_resource_group.az104_rg4.name
  private_dns_zone_name = azurerm_private_dns_zone.private.name
  virtual_network_id    = azurerm_virtual_network.mfg_vnet.id
  registration_enabled  = true
}

resource "azurerm_private_dns_a_record" "sensor_vm" {
  name                = "sensorvm"
  zone_name           = azurerm_private_dns_zone.private.name
  resource_group_name = azurerm_resource_group.az104_rg4.name
  ttl                 = 3600
  records             = ["10.1.1.4"]
}
