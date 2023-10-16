variable "azurerm_subscriptionId" {
    description = "Provide value of subscription ID"
    type = string
    default = ""
   
}
variable "azurerm_clientId" {
    description = "Provide value of client ID"
    type = string
    default = ""
   
}

variable "azurerm_clintSecret" {
    description = "Provide value of client Sercret"
    type = string
    default = ""
   
}

variable "azurerm_tenantId" {
    description = "Provide value of Tenant ID"
    type = string
    default = ""
   
}


variable "azurerm_resource_group" {
  type = string
  description = "Provide Resource group name" 
  default = ""
}

variable "location" {
  type = string
  description = "Provide location name"
  default = ""
}

variable "azurerm_virtual_network" {
    description = "Creating Virtual Network for 3 tier Application"
    type = string
    default = ""
  
}

variable "azurerm_Subnet_Web" {
    default = "webTierSubnet"
    description = "Creating public subnet"
  
}

