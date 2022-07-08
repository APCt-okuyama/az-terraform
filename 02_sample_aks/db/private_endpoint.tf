resource "azurerm_private_endpoint" "for_psql" {
  name                = local.pe_name
  location            = var.location
  resource_group_name = var.rg_name_service
  subnet_id           = var.subnet_id_pl

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [azurerm_private_dns_zone.for_psql.id]
  }

  private_service_connection {
    name                           = "sqlconnection"
    private_connection_resource_id = azurerm_postgresql_server.psql.id
    is_manual_connection           = false
    subresource_names              = ["postgresqlServer"]
  }
}