
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

resource "azurerm_resource_group" "az104_rg3" {
  name     = "az104-rg3"
  location = "East US"
}

resource "azurerm_managed_disk" "az104_disk1" {
  name                 = "az104-disk1"
  location             = azurerm_resource_group.az104_rg3.location
  resource_group_name  = azurerm_resource_group.az104_rg3.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = 32

  tags = {
    environment = "lab"
  }
}

output "managed_disk_id" {
  value = azurerm_managed_disk.az104_disk1.id
}
