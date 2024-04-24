terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.100.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Create resource group
#Resource group
resource "azurerm_resource_group" "rg" {
  name      = var.resource_group_name
  location  = var.resource_group_location
}
