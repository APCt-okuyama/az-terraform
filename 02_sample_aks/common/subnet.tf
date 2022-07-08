resource "azurerm_subnet" "subnet-aks" {
  name                 = var.subnet_aks_name
  virtual_network_name = azurerm_virtual_network.example.name
  resource_group_name  = azurerm_resource_group.service.name
  address_prefixes     = var.subnet_aks_address_prefixes
}

resource "azurerm_subnet" "subnet-psql-pl" {
  name                 = var.subnet_pl_name
  virtual_network_name = azurerm_virtual_network.example.name
  resource_group_name  = azurerm_resource_group.service.name
  address_prefixes     = var.subnet_pl_address_prefixes
  enforce_private_link_endpoint_network_policies = true
}

resource "azurerm_subnet" "subnet-agw" {
  name                 = var.subnet_agw_name
  virtual_network_name = azurerm_virtual_network.example.name
  resource_group_name  = azurerm_resource_group.service.name
  address_prefixes     = var.subnet_agw_address_prefixes
}
