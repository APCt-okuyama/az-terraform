resource "azurerm_postgresql_server" "psql" {
  name                = local.psql_name
  resource_group_name = var.rg_name
  location            = var.location

  sku_name                      = "GP_Gen5_2"
  version                       = "11"
  storage_mb                    = 5120
  administrator_login           = var.psql_admin_user
  administrator_login_password  = var.psql_admin_password
  public_network_access_enabled = false
  ssl_enforcement_enabled       = true
  geo_redundant_backup_enabled  = false
  auto_grow_enabled             = false
}

resource "azurerm_postgresql_database" "psql_database" {
  name                = var.psql_database_name
  resource_group_name = var.rg_name
  server_name         = azurerm_postgresql_server.psql.name
  charset             = "UTF8"
  collation           = "English_United States.1252"
}
