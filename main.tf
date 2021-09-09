# Azure provider confirguration :
terraform {
  required_providers {
    azurerm = {
    source  = "hashicorp/azurerm"
    version = "=2.46.0"
    }

  }
  backend "azurerm" {
    resource_group_name  = "Week2-September"
    storage_account_name = "tfsimplon"
    container_name       = "tf-blob"
    key                  = "dev.terraform.tfstate"
  }
}

  provider "azurerm" {
  features {}
  subscription_id = var.subscription
}

# Virtual network :
resource "azurerm_virtual_network" "vnet-tf" {
  name                = "virtualNetworktf"
  location            = var.location
  resource_group_name = var.rg_name
  address_space       = ["10.0.0.0/16"]
}