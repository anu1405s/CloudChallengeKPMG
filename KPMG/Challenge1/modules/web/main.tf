#create public subnet for jumpbox Virtual Machine and web tier
resource "azurerm_subnet" "publicSubnet" {
    name = var.azurerm_Subnet_Web
    resource_group_name = var.azurerm_resource_group
    virtual_network_name = var.azurerm_virtual_network
    address_prefixes = ["10.0.1.0/24"]
}

#Create public Ip Address
resource "azurerm_public_ip" "pulicIP" {
    name= "web-PublicIP"
    resource_group_name = var.azurerm_resource_group
    location =  var.location
    allocation_method = "Dynamic"

}
#create NSG for jumpbox and web tier
resource "azurerm_network_security_group" "webNSG" {
    name = "web-NSG"
    resource_group_name = var.azurerm_resource_group
    location = var.location

    security_rule {
    name                       = "webRule"
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

#Create network security Interface
resource "azurerm_network_interface" "webNIC" {
  name= "web-NIC"
  resource_group_name= var.azurerm_resource_group
  location= var.location

  ip_configuration{
    name= "webNIC-config"
    subnet_id= azurerm_subnet.publicSubnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id=azurerm_public_ip.pulicIP.id
  }
  
}

#Associate NSG with jumpbox and web tier subnet
resource "azurerm_subnet_network_security_group_association" "webNsgAssociation" {
    subnet_id= azurerm_subnet.publicSubnet.id
    network_security_group_id= azurerm_network_security_group.webNSG.id  
}

#Create Application Gateway
resource "azurerm_application_gateway" "webAppGateway" {
    name= "web-apgw"
    resource_group_name = var.azurerm_resource_group
    location = var.location
    sku {
      name= "Standard_Small"
      tier = "Standard"
      capacity=2
    }
    gateway_ip_configuration {
      name = "web-gateway"
      subnet_id = azurerm_subnet.publicSubnet.id
    }
    frontend_port {
      name="web-http-port"
      port = 80
    }
    frontend_ip_configuration {
      name="web-frontedIP"
      public_ip_address_id = azurerm_public_ip.pulicIP.id
    }
    backend_address_pool {
        name = "Web-BackendPool"
    }
     backend_http_settings {
        name = "web-BackendSettting"
        protocol = "Http"
        port = 80
        cookie_based_affinity = "Disabled"
        request_timeout = 30
        path = "/web" 
    }
    http_listener {
      name="webhttpListener"
      frontend_ip_configuration_name = "web-frontedIP"
      frontend_port_name = "web-http-port"
      protocol = "Http"
    }
   
    request_routing_rule {
        name = "webRule"
        rule_type = "Basic"
        http_listener_name = "webhttpListener"
        backend_address_pool_name = "Web-BackendPool"
        backend_http_settings_name = "web-BackendSettting"
    }
    
}


# Create a public virtual Machine with public IP Address
resource "azurerm_virtual_machine" "public_VM" {
  name                  = "public-VM"
  resource_group_name   = var.azurerm_resource_group
  location              = var.location
  network_interface_ids = [azurerm_network_interface.webNIC.id]
  vm_size               = "Standard_DS1_v2"

  storage_os_disk {
    name              = "osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
  }
}

#Virtual machine scale set
resource "azurerm_orchestrated_virtual_machine_scale_set" "PrivateScaleSet" {
  name = "Private_VM_ScaleSet"
  resource_group_name = var.azurerm_resource_group
  location = var.location
 
  platform_fault_domain_count = 1

  zones = ["1"]


}
