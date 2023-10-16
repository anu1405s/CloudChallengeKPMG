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

variable "azurerm_Subnet_Web" {
    default = "webTierSubnet"
    description = "Creating public subnet"
  
}
# variable "azurerm_virtual_machine" {
#     name= 
#     default = 
#     description = "value"
  
# }

# variable "vm_size" {
#     name= 
#     default = 
#     description = "value"
  
# }