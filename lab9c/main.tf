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

resource "azurerm_resource_group" "rg9c" {
  name     = "az104-rg9c"
  location = "West Europe"
}

resource "azurerm_container_app_environment" "env" {
  name                = "my-environment-vfufalko"
  location            = azurerm_resource_group.rg9c.location
  resource_group_name = azurerm_resource_group.rg9c.name
}

resource "azurerm_container_app" "app" {
  name                         = "my-app-vfufalko"
  container_app_environment_id = azurerm_container_app_environment.env.id
  resource_group_name          = azurerm_resource_group.rg9c.name
  revision_mode                = "Single"

  template {
    container {
      name   = "hello-world-container"
      image  = "mcr.microsoft.com/azuredocs/containerapps-helloworld:latest"
      cpu    = 0.25
      memory = "0.5Gi"
    }
  }

  ingress {
    allow_insecure_connections = false
    external_enabled           = true
    target_port                = 80
    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
  }
}
