/**
 * このコメントは terraform-docs でそのまま出力されます
 */

# resource group
resource "azurerm_resource_group" "example" {
  name     = "${local.rg_name}"
  location = local.location
}



# key vault
data "azurerm_client_config" "current" {}
resource "azurerm_key_vault" "example" {
  name                        = "${local.keyvault_name}"
  location                    = azurerm_resource_group.example.location
  resource_group_name         = azurerm_resource_group.example.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    # key_permissions = [
    #   "Get",
    # ]

    secret_permissions = [
      "List",
      "Set",
      "Get",
      "Delete",
      "Purge"
    ]

    # storage_permissions = [
    #   "Get",
    # ]
  }
}

# app service plan (linux)
resource "azurerm_service_plan" "example" {
  name                = "${local.appservice_plan_name}"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  os_type             = "Linux"
  sku_name            = "B1"
  # F1 free
  # B1 13.87 USD
  # S1 81.76 USD
  # P1v2 89.79 USDB
}

resource "azurerm_linux_web_app" "example" {
  name                = "${local.appservice_name}"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  service_plan_id     = azurerm_service_plan.example.id
  https_only            = true

  identity {
    #システム割り当てマネージド ID　を利用します
    type = "SystemAssigned"
  }

  site_config {
    application_stack {
      python_version = "3.7"
    }
  }

  app_settings = {
    # # key valueから設定する
    # # @Microsoft.KeyVault(SecretUri=https://yelpcamp-example-kv.vault.azure.net//secrets/ExamplePassword/xxx)
    # # db connection string (DB_URL)
    # DB_URL = "@Microsoft.KeyVault(SecretUri=${azurerm_key_vault_secret.example.id})"
    # # external api key (MAPBOX_TOKEN)
    # MAPBOX_TOKEN = "@Microsoft.KeyVault(SecretUri=${azurerm_key_vault_secret.example2.id})"
    #デプロイ時にソースを自動ビルドするかどうか
    #デプロイ時にソースを自動ビルドを実施する仕組み (Oryx) 
    SCM_DO_BUILD_DURING_DEPLOYMENT = "true"
    ENABLE_ORYX_BUILD = "true"
  }  
}

resource "azurerm_linux_web_app" "example-spa" {
  name                = "${local.appservice_spa_name}"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  service_plan_id     = azurerm_service_plan.example.id
  https_only            = true

  identity {
    #システム割り当てマネージド ID　を利用します
    type = "SystemAssigned"
  }

  site_config {
  }
}

# key vault のアクセスポリシーにapp serviceを追加
#  ※注意 設定が有効になるまでに少し時間がかかる？　
resource "azurerm_key_vault_access_policy" "example" {
  key_vault_id = azurerm_key_vault.example.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_linux_web_app.example.identity[0].principal_id
  secret_permissions = [
    "Get",
  ]
}

#
# azure blob storage webホスティング用
#
resource "azurerm_storage_account" "example" {
  name                     = "${local.blob_storage_ac_name}"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  # static web を有効に。
  static_website {
    index_document = "${local.spa_index_document_name}"
  }  
}

resource "azurerm_storage_blob" "example" {
  name                   = "${local.spa_index_document_name}"
  storage_account_name   = azurerm_storage_account.example.name
  storage_container_name = "$web"
  type                   = "Block"
  content_type           = "text/html"

  source_content         = "<h1>This is coming from azure storage.</h1><p>You can deploy your awsome contents(spa).</p><h2>Azure CLI</h2><p>az storage blob upload-batch -s SOURCE-PATH -d '$web' --account-name ${local.blob_storage_ac_name}</p>"
}

#
# Functions
#
resource "azurerm_storage_account" "example4func" {
  name                     = "${local.func_storage_name1}"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
resource "azurerm_linux_function_app" "example" {
  name                = "${local.func_app_name1}"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location

  storage_account_name       = azurerm_storage_account.example4func.name
  storage_account_access_key = azurerm_storage_account.example4func.primary_access_key
  service_plan_id            = azurerm_service_plan.example.id

  app_settings = {
    FUNCTIONS_WORKER_RUNTIME= "python"
    FUNCTIONS_EXTENSION_VERSION = "~4"
  }

  site_config {
    application_stack {
      python_version = "3.7"
    }
  }
}
resource "azurerm_storage_account" "example4func2" {
  name                     = "${local.func_storage_name2}"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
resource "azurerm_linux_function_app" "example2" {
  name                = "${local.func_app_name2}"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location

  storage_account_name       = azurerm_storage_account.example4func2.name
  storage_account_access_key = azurerm_storage_account.example4func2.primary_access_key
  service_plan_id            = azurerm_service_plan.example.id

  app_settings = {
    FUNCTIONS_WORKER_RUNTIME= "python"
    FUNCTIONS_EXTENSION_VERSION = "~4"
  }
  
  site_config {
    application_stack {
      python_version = "3.7"
    }
  }
}

resource "azurerm_mysql_server" "example" {
  name                = "${local.mysql_server_name}"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  administrator_login          = "${local.mysql_admin_user}"
  administrator_login_password = "${local.mysql_admin_password}"

  sku_name   = "GP_Gen5_2"
  storage_mb = 5120
  version    = "5.7"

  auto_grow_enabled                 = true
  backup_retention_days             = 7
  geo_redundant_backup_enabled      = true
  infrastructure_encryption_enabled = true
  public_network_access_enabled     = false
  ssl_enforcement_enabled           = true
  ssl_minimal_tls_version_enforced  = "TLS1_2"
}

resource "azurerm_mysql_database" "example" {
  name                = "${local.mysql_db_name1}"
  resource_group_name = azurerm_resource_group.example.name
  server_name         = azurerm_mysql_server.example.name
  charset             = "utf8"
  collation           = "utf8_unicode_ci"
}
# mysql -h example-mysqlserver-29422.mysql.database.azure.com -u apcsqladmin@example-mysqlserver-29422 -p
# mysql dbの接続文字列をKeyVaultへいれる
