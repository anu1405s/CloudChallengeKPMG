#create private subnet for database tier
resource "azurerm_subnet" "privateDBSubnet" {
    name = "dbSubnet"
    resource_group_name = var.azurerm_resource_group
    virtual_network_name = var.azurerm_virtual_network
    address_prefixes = ["10.0.1.0/24"]
}

#create NSG for database tier
resource "azurerm_network_security_group" "dbNSG" {
    name = "db-NSG"
    resource_group_name = var.azurerm_resource_group
    location = var.location

    security_rule {
    name                       = "dbRule"
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

#Associate NSG with database tier subnet
resource "azurerm_subnet_network_security_group_association" "dbNsgAssociation" {
    subnet_id= azurerm_subnet.privateDBSubnet.id
    network_security_group_id= azurerm_network_security_group.dbNSG.id
  
}

#create primary my sql server
resource "azurerm_mssql_server" "primaryServer" {
    name = "mysqlserver"
    resource_group_name = var.azurerm_resource_group
    location = var.location
    version = "12.0"
    administrator_login = "myadmin"
    administrator_login_password = "Password1234@"  
}

#Create MySQl Database
resource "azurerm_mssql_database" "mySQLDatabase" {
    name = "mssqldatabase"
    server_id = azurerm_mssql_server.primaryServer.id
}
    

#Create MySQL server for replica
resource "azurerm_mssql_server" "replicaServer" {
    name = "replicamysqlserver"
    resource_group_name = var.azurerm_resource_group
    location = var.location
    version = "12.0"
    administrator_login = "myadmin"
    administrator_login_password = "Password1234@" 
   
}

#Create MySQl Database
resource "azurerm_mssql_database" "replicaServer" {
    name = "mssqldatabase"
    server_id = azurerm_mssql_server.primaryServer.id
}

# #Create replica of MySQL Database
# resource "azurerm_sql_replica" "mySQLReplica" {
#     name="MySQL-Replica"
#     resource_group_name= var.azurerm_resource_group
#     server_name=azurerm_mysql_server.replicaServer.name
#     source_server_id= azurerm_mysql_server.primary.id
# }

#create firewall rules for primary mysql
resource "azurerm_mssql_firewall_rule" "primaryRule" {
    name="primaryFirewallRule"
    server_id = azurerm_mssql_server.primaryServer.id
    start_ip_address = "10.0.17.62"
    end_ip_address = "10.0.17.62"
  
}

resource "azurerm_mssql_firewall_rule" "replicaRule" {
    name="primaryFirewallRule"
    server_id = azurerm_mssql_server.replicaServer.id
    start_ip_address = "10.0.17.62"
    end_ip_address = "10.0.17.62"
  
}

#create firewall rules for replica mysql
resource "azurerm_mysql_firewall_rule" "replicaRule" {
    name="replicaFirewallRule"
    resource_group_name = var.azurerm_resource_group
    server_name = azurerm_mssql_server.replicaServer.name
    start_ip_address = "10.0.17.62"
    end_ip_address = "10.0.17.62"
  
}

#create firewall rules to sync replica of mysql
# resource "azurerm_mssql_firewall_rule" "replicaSync" {
#     name="MYSQL-ReplicaSync"
#     resource_group_name = var.azurerm_resource_group
#     server_name = azurerm_mysql_server.replicaServer.name
#     start_ip_address = azurerm_mysql_server.primaryServer.fqdn
#     end_ip_address = azurerm_mysql_server.primaryServer.fqdn
  
# }
