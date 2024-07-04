# Définition des groupes de ressources
resource "azurerm_resource_group" "ops_network_rg" {
  name     = "ops-network-rg"
  location = "westeurope"
}

resource "azurerm_resource_group" "ops_service_rg" {
  name     = "ops-service-rg"
  location = "westeurope"
}

resource "azurerm_resource_group" "app_01_rg" {
  name     = "APP-01-rg"
  location = "westeurope"
}

resource "azurerm_resource_group" "app_02_rg" {
  name     = "APP-02-rg"
  location = "westeurope"
}


# Déclaration du resource random_integer pour web-app-01
resource "random_integer" "ri_01" {
  min = 1000
  max = 9999
}

# Déclaration du resource random_integer pour web-app-02
resource "random_integer" "ri_02" {
  min = 1000
  max = 9999
}

# Réseau virtuel pour les opérations
resource "azurerm_virtual_network" "vnet_ops" {
  name                = "vnet-ops"
  address_space       = ["10.10.10.0/24"]
  location            = azurerm_resource_group.ops_network_rg.location
  resource_group_name = azurerm_resource_group.ops_network_rg.name
}

# Réseau virtuel pour les applications
resource "azurerm_virtual_network" "vnet_app" {
  name                = "vnet-app"
  address_space       = ["10.10.20.0/24"]
  location            = azurerm_resource_group.ops_network_rg.location
  resource_group_name = azurerm_resource_group.ops_network_rg.name
}

# Sous-réseaux pour les opérations
resource "azurerm_subnet" "subnet_ops" {
  count               = 4
  name                = element(["subnet-Bind", "subnet-squid", "subnet-haproxy", "subnet-routeur-fw"], count.index)
  address_prefixes    = [element(["10.10.10.0/27", "10.10.10.32/27", "10.10.10.64/27", "10.10.10.96/27"], count.index)]
  resource_group_name = azurerm_virtual_network.vnet_ops.resource_group_name
  virtual_network_name= azurerm_virtual_network.vnet_ops.name
}

resource "azurerm_subnet" "subnet_app" {
  count               = 2
  name                = element(["subnet-app-01", "subnet-app-02"], count.index)
  address_prefixes    = [element(["10.10.20.0/27", "10.10.20.32/27"], count.index)]
  resource_group_name = azurerm_virtual_network.vnet_app.resource_group_name
  virtual_network_name= azurerm_virtual_network.vnet_app.name

  delegation {
    name = "AppServiceLink"
    service_delegation {
      name    = "Microsoft.Web/serverFarms"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/action"
      ]
    }
  }
}

# Définir les interfaces réseau et les machines virtuelles pour chaque application
resource "azurerm_network_interface" "nic_bind" {
  name                = "nic-bind"
  location            = azurerm_resource_group.ops_service_rg.location
  resource_group_name = azurerm_resource_group.ops_service_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet_ops[0].id
    private_ip_address_allocation = "Static"
  }
}

resource "azurerm_network_interface" "nic_squid" {
  name                = "nic-squid"
  location            = azurerm_resource_group.ops_service_rg.location
  resource_group_name = azurerm_resource_group.ops_service_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet_ops[1].id
    private_ip_address_allocation = "Static"
  }
}

resource "azurerm_network_interface" "nic_haproxy" {
  name                = "nic-haproxy"
  location            = azurerm_resource_group.ops_service_rg.location
  resource_group_name = azurerm_resource_group.ops_service_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet_ops[2].id
    private_ip_address_allocation = "Static"
  }
}

resource "azurerm_network_interface" "nic_router_fw" {
  name                = "nic-router-fw"
  location            = azurerm_resource_group.ops_service_rg.location
  resource_group_name = azurerm_resource_group.ops_service_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet_ops[3].id
    private_ip_address_allocation = "Static"
  }
}

resource "azurerm_virtual_machine" "vm_bind" {
  name                  = "vm-bind"
  location              = azurerm_resource_group.ops_service_rg.location
  resource_group_name   = azurerm_resource_group.ops_service_rg.name
  network_interface_ids = [azurerm_network_interface.nic_bind.id]
  vm_size               = "Standard_DS1_v2"

  storage_os_disk {
    name              = "osdisk-bind"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  os_profile {
    computer_name  = "vm-bind"
    admin_username = "adminuser"
    admin_password = "Password123!"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
}

resource "azurerm_virtual_machine" "vm_squid" {
  name                  = "vm-squid"
  location              = azurerm_resource_group.ops_service_rg.location
  resource_group_name   = azurerm_resource_group.ops_service_rg.name
  network_interface_ids = [azurerm_network_interface.nic_squid.id]
  vm_size               = "Standard_DS1_v2"

  storage_os_disk {
    name              = "osdisk-squid"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  os_profile {
    computer_name  = "vm-squid"
    admin_username = "adminuser"
    admin_password = "Password123!"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
}

resource "azurerm_virtual_machine" "vm_haproxy" {
  name                  = "vm-haproxy"
  location              = azurerm_resource_group.ops_service_rg.location
  resource_group_name   = azurerm_resource_group.ops_service_rg.name
  network_interface_ids = [azurerm_network_interface.nic_haproxy.id]
  vm_size               = "Standard_DS1_v2"

  storage_os_disk {
    name              = "osdisk-haproxy"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  os_profile {
    computer_name  = "vm-haproxy"
    admin_username = "adminuser"
    admin_password = "Password123!"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
}

resource "azurerm_virtual_machine" "vm_router_fw" {
  name                  = "vm-router-fw"
  location              = azurerm_resource_group.ops_service_rg.location
  resource_group_name   = azurerm_resource_group.ops_service_rg.name
  network_interface_ids = [azurerm_network_interface.nic_router_fw.id]
  vm_size               = "Standard_DS1_v2"

  storage_os_disk {
    name              = "osdisk-router-fw"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  os_profile {
    computer_name  = "vm-router-fw"
    admin_username = "adminuser"
    admin_password = "Password123!"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
}

# Création du plan de service App Azure (App Service Plan) pour web-app-01
resource "azurerm_service_plan" "app_service_plan_01" {
  name                = "webapp-asp-01-${random_integer.ri_01.result}"
  location            = azurerm_resource_group.app_01_rg.location
  resource_group_name = azurerm_resource_group.app_01_rg.name
  os_type             = "Windows"
  sku_name            = "B1"
}

## Création de l'application web web-app-01
resource "azurerm_app_service" "app_service_01" {
  name                = "web-app-01-${random_integer.ri_01.result}"
  location            = azurerm_resource_group.app_01_rg.location
  resource_group_name = azurerm_resource_group.app_01_rg.name
  app_service_plan_id = azurerm_service_plan.app_service_plan_01.id
  https_only          = true
  
  site_config {
    min_tls_version = "1.2"
    default_documents = ["Default.html", "Default.htm", "Index.html", "Index.htm"]   
  }
  
  app_settings = {
    "WEBSITE_RUN_FROM_PACKAGE" = "1"
  }

  connection_string {
    name  = "Database"
    type  = "SQLServer"
    value = "Server=some-server.mydomain.com;Integrated Security=SSPI"
  }
  
  auth_settings {
    enabled = true
  }

  depends_on = [
    azurerm_subnet.subnet_app  
  ]

  lifecycle {
    prevent_destroy = false
  }
}
resource "azurerm_app_service_virtual_network_swift_connection" "app_service_vnet_integration_01" {
  app_service_id      = azurerm_app_service.app_service_01.id
  subnet_id           = azurerm_subnet.subnet_app[0].id
}

# Création du plan de service App Azure (App Service Plan) pour web-app-02
resource "azurerm_service_plan" "app_service_plan_02" {
  name                = "webapp-asp-02-${random_integer.ri_02.result}"
  location            = azurerm_resource_group.app_02_rg.location
  resource_group_name = azurerm_resource_group.app_02_rg.name
  os_type             = "Windows"
  sku_name            = "B1"
}

# Création de l'application web web-app-02
resource "azurerm_app_service" "app_service_02" {
  name                = "web-app-02-${random_integer.ri_02.result}"
  location            = azurerm_resource_group.app_02_rg.location
  resource_group_name = azurerm_resource_group.app_02_rg.name
  app_service_plan_id = azurerm_service_plan.app_service_plan_02.id
  https_only          = true

  site_config {
    min_tls_version = "1.2" 
    default_documents = ["Default.html", "Default.htm", "Index.html", "Index.htm"] 
  }
  
  app_settings = {
    "WEBSITE_RUN_FROM_PACKAGE" = "1"
  }

  connection_string {
    name  = "Database"
    type  = "SQLServer"
    value = "Server=some-server.mydomain.com;Integrated Security=SSPI"
  }

  auth_settings {
    enabled = true
  }
  
  depends_on = [
    azurerm_subnet.subnet_app  # Dépend du sous-réseau approprié
  ]

  lifecycle {
    prevent_destroy = false
  }
}
resource "azurerm_app_service_virtual_network_swift_connection" "app_service_vnet_integration_02" {
  app_service_id      = azurerm_app_service.app_service_02.id
  subnet_id           = azurerm_subnet.subnet_app[1].id
}

# Création du serveur SQL pour APP-01-rg
resource "azurerm_mssql_server" "sql_server_01" {
  name                         = "sql-server-app-01-${random_integer.ri_01.result}"
  resource_group_name          = azurerm_resource_group.app_01_rg.name
  location                     = azurerm_resource_group.app_01_rg.location
  version                      = "12.0"
  administrator_login          = "sqladmin01"  # Remplacer par vos variables ou valeurs
  administrator_login_password = "Password01"  # Remplacer par vos variables ou valeurs
}

# Création du serveur SQL pour APP-02-rg
resource "azurerm_mssql_server" "sql_server_02" {
  name                         = "sql-server-app-02-${random_integer.ri_02.result}"
  resource_group_name          = azurerm_resource_group.app_02_rg.name
  location                     = azurerm_resource_group.app_02_rg.location
  version                      = "12.0"
  administrator_login          = "sqladmin02"  # Remplacer par vos variables ou valeurs
  administrator_login_password = "Password02"  # Remplacer par vos variables ou valeurs
}

