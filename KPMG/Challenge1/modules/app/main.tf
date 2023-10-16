#create private subnet for app tier
resource "azurerm_subnet" "privateAppSubnet" {
    name = "appSubnet"
    resource_group_name = var.azurerm_resource_group
    virtual_network_name = var.azurerm_virtual_network
    address_prefixes = ["10.0.1.0/24"]
}

#create NSG for app tier
resource "azurerm_network_security_group" "AppNSG" {
    name = "App-NSG"
    resource_group_name = var.azurerm_resource_group
    location = var.location

    security_rule {
    name                       = "appRule"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  
}

#Associate NSG with app tier subnet
resource "azurerm_subnet_network_security_group_association" "appNsgAssociation" {
    subnet_id= azurerm_subnet.privateAppSubnet.id
    network_security_group_id= azurerm_network_security_group.AppNSG.id  
}

resource "azurerm_network_interface" "appNIC" {
  name = "App-NIC"
  location = var.location
  resource_group_name = var.azurerm_resource_group

  ip_configuration {  
    name="app-ip-config"
    subnet_id = azurerm_subnet.privateAppSubnet.id
    private_ip_address_allocation = "Dynamic"
  }
  
}

#Create Public Ip for load balancer
resource "azurerm_public_ip" "azlbpublicIP" {
  name                = "lb-publicip"
  location            = var.location
  resource_group_name = var.azurerm_resource_group
  allocation_method   = "Static"
}

# Create Azure load balancer
resource "azurerm_lb" "loadBalancer" {
    name = "appLB"
    resource_group_name = var.azurerm_resource_group
    location = var.location
    sku = "Standard"

    frontend_ip_configuration {
      name ="public"
      public_ip_address_id = azurerm_public_ip.azlbpublicIP.id
    }
    
}

# Associate Azure Load Blancer with App subnet
resource "azurerm_subnet_network_security_group_association" "lbAssociation" {
    subnet_id = azurerm_subnet.privateAppSubnet.id
    network_security_group_id = azurerm_network_security_group.AppNSG.id
  
}

# Create a virtual Machine with private IP Address
resource "azurerm_virtual_machine" "privateVM" {
  name                  = "app-VM"
  location              = var.location
  resource_group_name   = var.azurerm_resource_group
  network_interface_ids = [azurerm_network_interface.appNIC.id]
  vm_size               = "Standard_DS2_v2"

  storage_os_disk {
    name              = "osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
  }
}

#Virtual machine scale set
resource "azurerm_orchestrated_virtual_machine_scale_set" "ScaleSet" {
  name = "VM_ScaleSet"
  resource_group_name = var.azurerm_resource_group
  location = var.location
 
  platform_fault_domain_count = 1

  zones = ["1"]


}