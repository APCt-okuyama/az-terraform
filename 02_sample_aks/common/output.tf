output "author" {
    value = var.author
}

output "rg_common_name" {
    value = azurerm_resource_group.common.name
}

output "rg_common_location" {
    value = azurerm_resource_group.common.location
}

output "rg_service_name" {
    value = azurerm_resource_group.service.name
}

output "rg_service_location" {
    value = azurerm_resource_group.service.location
}

output "vnet_id" {
    value = azurerm_virtual_network.example.id
}

output "subnet_id_aks" {
    value = azurerm_subnet.subnet-aks.id
}

output "subnet_id_pl" {
    value = azurerm_subnet.subnet-psql-pl.id
}