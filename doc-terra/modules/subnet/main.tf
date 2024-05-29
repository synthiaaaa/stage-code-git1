provider "azurerm" {
  features {}
}

resource "azurerm_subnet" "subnet" {
  name                 = var.subnet_name
  resource_group_name  = "cyntia-rg"  # Utilisez le nom de votre groupe de ressources ici
  virtual_network_name = var.virtual_network_name
  address_prefixes     = [var.subnet_cidr_block]
}
