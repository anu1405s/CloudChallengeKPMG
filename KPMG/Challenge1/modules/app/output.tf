output "private_ip" {
    value= azurerm_network_interface.appNIC.private_ip_address
}

output "app_nsg_id"  {
    value=azurerm_network_security_group.AppNSG.id
}

output "lb_id" {
    value = azurerm_lb.loadBalancer.id
}