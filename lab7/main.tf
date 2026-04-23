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

resource "azurerm_resource_group" "rg7" {
  name     = "az104-rg7"
  location = "West US 2"
}

resource "random_string" "random" {
  length  = 6
  special = false
  upper   = false
}

data "http" "myip" {
  url = "https://ifconfig.me/ip"
}

resource "azurerm_virtual_network" "vnet1" {
  name                = "vnet1"
  address_space       = ["10.70.0.0/22"]
  location            = azurerm_resource_group.rg7.location
  resource_group_name = azurerm_resource_group.rg7.name
}

resource "azurerm_subnet" "subnet0" {
  name                 = "default"
  resource_group_name  = azurerm_resource_group.rg7.name
  virtual_network_name = azurerm_virtual_network.vnet1.name
  address_prefixes     = ["10.70.0.0/24"]
  service_endpoints    = ["Microsoft.Storage"]
}

resource "azurerm_storage_account" "stg" {
  name                          = "az104stg7${random_string.random.result}"
  resource_group_name           = azurerm_resource_group.rg7.name
  location                      = azurerm_resource_group.rg7.location
  account_tier                  = "Standard"
  account_replication_type      = "GRS"
  public_network_access_enabled = true

  network_rules {
    default_action             = "Deny"
    ip_rules                   = [data.http.myip.response_body]
    virtual_network_subnet_ids = [azurerm_subnet.subnet0.id]
  }
}

resource "azurerm_storage_management_policy" "policy" {
  storage_account_id = azurerm_storage_account.stg.id

  rule {
    name    = "Movetocool"
    enabled = true
    filters {
      blob_types = ["blockBlob"]
    }
    actions {
      base_blob {
        tier_to_cool_after_days_since_modification_greater_than = 30
      }
    }
  }
}

resource "azurerm_storage_container" "data" {
  name                  = "data"
  storage_account_id    = azurerm_storage_account.stg.id
  container_access_type = "private"
}

resource "azurerm_storage_container_immutability_policy" "policy" {
  storage_container_resource_manager_id = azurerm_storage_container.data.resource_manager_id
  immutability_period_in_days           = 180
}

resource "azurerm_storage_share" "share1" {
  name               = "share1"
  storage_account_id = azurerm_storage_account.stg.id
  quota              = 50
  access_tier        = "TransactionOptimized"
}
