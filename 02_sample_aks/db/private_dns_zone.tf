resource "azurerm_private_dns_zone" "for_psql" {
  name                = var.pdnsz_name
  resource_group_name = var.rg_name_service

  lifecycle {
    ignore_changes = [number_of_record_sets]
  }
}

resource "azurerm_private_dns_zone_virtual_network_link" "for_psql" {
  name                  = local.pdnsz_vnet_link_name
  resource_group_name   = var.rg_name_service
  private_dns_zone_name = azurerm_private_dns_zone.for_psql.name
  virtual_network_id    = var.vnet_id
}