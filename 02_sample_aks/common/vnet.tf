resource "azurerm_virtual_network" "example" {
  name                = local.vnet_name
  location            = azurerm_resource_group.service.location
  resource_group_name = azurerm_resource_group.service.name
  address_space       = var.vnet_address_space
}
