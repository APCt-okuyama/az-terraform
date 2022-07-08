resource "azurerm_resource_group" "common" {
  name     = local.rg_name_common
  location = var.location
}

resource "azurerm_resource_group" "service" {
  name     = local.rg_name_service
  location = var.location
}

