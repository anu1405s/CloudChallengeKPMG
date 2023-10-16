output "public_IP" {
    value = azurerm_public_ip.pulicIP
}

output "Gateway_id" {
    value = azurerm_application_gateway.webAppGateway.id 
}

output "web_nsg_id"  {
    value=azurerm_network_security_group.webNSG.id
}
