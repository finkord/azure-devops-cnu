
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


resource "azurerm_resource_group" "az104_rg4" {
  name     = "az104-rg4"
  location = "East US"
}

resource "azurerm_virtual_network" "core_vnet" {
  name                = "CoreServicesVnet"
  address_space       = ["10.20.0.0/16"]
  location            = azurerm_resource_group.az104_rg4.location
  resource_group_name = azurerm_resource_group.az104_rg4.name

  subnet {
    name             = "SharedServicesSubnet"
    address_prefixes = ["10.20.10.0/24"]
  }

  subnet {
    name             = "DatabaseSubnet"
    address_prefixes = ["10.20.20.0/24"]
  }
}
