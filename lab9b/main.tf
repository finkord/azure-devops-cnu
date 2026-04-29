terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg9b" {
  name     = "az104-rg9b"
  location = "West Europe"
}

resource "random_id" "dns_suffix" {
  byte_length = 4
}

resource "azurerm_container_group" "aci1" {
  name                = "az104-c1"
  location            = azurerm_resource_group.rg9b.location
  resource_group_name = azurerm_resource_group.rg9b.name
  ip_address_type     = "Public"
  dns_name_label      = "az104-vfufalko-${random_id.dns_suffix.hex}"
  os_type             = "Linux"

  container {
    name   = "hello-world"
    image  = "mcr.microsoft.com/azuredocs/aci-helloworld:latest"
    cpu    = "0.5"
    memory = "1.5"

    ports {
      port     = 80
      protocol = "TCP"
    }
  }
}
