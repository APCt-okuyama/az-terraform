/**
 * このコメントは terraform-docs でそのまま出力されます
 */

# resource group
resource "azurerm_resource_group" "example" {
  name     = "${local.rg_name}"
  location = local.location
}

# container registory
resource "azurerm_container_registry" "acr" {
  name                = "${local.acr_name}"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  sku                 = "Basic"
  admin_enabled       = false
  # georeplications {
  #   location                = "Japan East"
  #   zone_redundancy_enabled = true
  #   tags                    = {}
  # }
  # georeplications {
  #   location                = "Japan West"
  #   zone_redundancy_enabled = true
  #   tags                    = {}
  # }
}

# ad b2c
resource "azurerm_aadb2c_directory" "example" {
  country_code            = "JP"
  data_residency_location = "Asia Pacific"
  display_name            = "${local.ad_b2c_name}"
  domain_name             = "${local.ad_b2c_domain_name}"
  resource_group_name     = azurerm_resource_group.example.name
  sku_name                = "PremiumP1"
}

# cosmos db
# resource "azurerm_cosmosdb_account" "example" {
#   name                = "${local.cosmos_account_name}"
#   location            = azurerm_resource_group.example.location
#   resource_group_name = azurerm_resource_group.example.name
#   offer_type          = "Standard"
#   kind                = "MongoDB"

#   enable_automatic_failover = false
#   capabilities {
#     name = "EnableMongo"
#   }

#   consistency_policy {
#     consistency_level       = "BoundedStaleness"
#     max_interval_in_seconds = 300
#     max_staleness_prefix    = 100000
#   }

#   geo_location {
#     location          = azurerm_resource_group.example.location
#     failover_priority = 0
#   }
# }

# resource "azurerm_cosmosdb_mongo_database" "example" {
#   name                = "${local.cosmos_db_name}"
#   resource_group_name = azurerm_cosmosdb_account.example.resource_group_name
#   account_name        = azurerm_cosmosdb_account.example.name
#   throughput          = 400
# }

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
# # cosmos dbの接続文字列をkeyVaultへ保持しておく ※connection_stringsは配列
# resource "azurerm_key_vault_secret" "example" {
#   name         = "DBURL"
#   value        = azurerm_cosmosdb_account.example.connection_strings[0]
#   key_vault_id = azurerm_key_vault.example.id
# }
# # MAPBOX_TOKEN を設定
# resource "azurerm_key_vault_secret" "example2" {
#   name         = "MAPBOXTOKEN"
#   value        = var.mapboxapitoken
#   key_vault_id = azurerm_key_vault.example.id
# }

# app service plan (linux)
resource "azurerm_service_plan" "example" {
  name                = "${local.appservice_plan_name}"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  os_type             = "Linux"
  sku_name            = "S1"
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
      node_version = "14-lts"
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

# azure blob storage webホスティング用
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

# Functions
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
    FUNCTIONS_WORKER_RUNTIME= "node"
    FUNCTIONS_EXTENSION_VERSION = "~4"
  }

  site_config {
    application_stack {
      node_version = "14"
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
    FUNCTIONS_WORKER_RUNTIME= "node"
    FUNCTIONS_EXTENSION_VERSION = "~4"
  }
  
  site_config {
    application_stack {
      node_version = "14"
    }
  }
}

# API Management
resource "azurerm_api_management" "example" {
  name                = "${local.apim_name}"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  publisher_name      = "${local.apim_publisher_name}"
  publisher_email     = "${local.apim_publisher_email}"

  sku_name = "Developer_1"
}