variable "azurerm_resource_group" {
  type = string
  description = "Provide Resource group name" 
}

variable "location" {
  type = string
  description = "Provide location name"
}

variable "azurerm_virtual_network" {
    description = "Creating Virtual Network for 3 tier Application"
    type = string
}