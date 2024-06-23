terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.109.0"
    }
  }
}

# Configuration option
provider "azurerm" {
  features {}
}