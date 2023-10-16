terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

provider "azurerm" {
    features{} 

    subscription_id = var.azurerm_subscriptionId
    client_id = var.azurerm_clientId
    client_secret = var.azurerm_clintSecret
    tenant_id = var.azurerm_tenantId
    
    
}

#create resource group
resource "azurerm_resource_group" "cloudRG" {
    name=var.azurerm_resource_group
    location = var.location
}

#Create Virtual Network for 3 tier application
resource "azurerm_virtual_network" "VNetwork" {
  name                = var.azurerm_virtual_network
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = var.azurerm_resource_group
  
}

# Create DNS Zone
resource "azurerm_dns_zone" "dnsZone" {
    name = "3tier-cloudchallenge.com"
    resource_group_name =var.azurerm_resource_group
  
}


module "web" {
  source= "./modules/web"
  azurerm_resource_group = var.azurerm_resource_group
  location = var.location
  azurerm_virtual_network = var.azurerm_virtual_network
}

module "app" {
  source= "./modules/app"
  azurerm_resource_group = var.azurerm_resource_group
  location = var.location
  azurerm_virtual_network = var.azurerm_virtual_network

}
module "db" {
  source= "./modules/database"
  azurerm_resource_group = var.azurerm_resource_group
  location = var.location
  azurerm_virtual_network = var.azurerm_virtual_network

}

