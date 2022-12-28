/**
 * このコメントは terraform-docs でそのまま出力されます
 */

################################################################################
# resource group
resource "azurerm_resource_group" "example" {
  name     = "${local.rg_name}"
  location = local.location
}

################################################################################
# ad b2c
# resource "azurerm_aadb2c_directory" "example" {
#   country_code            = "JP"
#   data_residency_location = "Asia Pacific"
#   display_name            = "${local.ad_b2c_name}"
#   domain_name             = "${local.ad_b2c_domain_name}"
#   resource_group_name     = azurerm_resource_group.example.name
#   sku_name                = "PremiumP1"
# }

################################################################################
# log workspace
resource "azurerm_log_analytics_workspace" "example" {
  name                = "${local.ws_name}"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}
################################################################################
# application insights
#  linux(app service) + python の組み合わせは コードレスの監視をサポートしていない
#  アプリ側に Application Insight SDK を組み込む必要があります。
resource "azurerm_application_insights" "example" {
  name                = "${local.ai_name}"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  workspace_id        = azurerm_log_analytics_workspace.example.id
  application_type    = "web"
}

# output "instrumentation_key" {
#   value = azurerm_application_insights.example.instrumentation_key
# }
# output "app_id" {
#   value = azurerm_application_insights.example.app_id
# }

################################################################################
# vnet&subnet
resource "azurerm_virtual_network" "example" {
  name                = "${local.vnet_name}"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}
resource "azurerm_subnet" "example" {
  name                 = "${local.snet_name}"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.2.0/24"]
}

################################################################################
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

################################################################################
# # container registory
# resource "azurerm_container_registry" "acr" {
#   name                = "${local.acr_name}"
#   resource_group_name = azurerm_resource_group.example.name
#   location            = azurerm_resource_group.example.location
#   sku                 = "Basic"
#   admin_enabled       = false
#   # georeplications {
#   #   location                = "Japan East"
#   #   zone_redundancy_enabled = true
#   #   tags                    = {}
#   # }
#   # georeplications {
#   #   location                = "Japan West"
#   #   zone_redundancy_enabled = true
#   #   tags                    = {}
#   # }
# }

################################################################################
# API Management
# resource "azurerm_api_management" "example" {
#   name                = "${local.apim_name}"
#   location            = azurerm_resource_group.example.location
#   resource_group_name = azurerm_resource_group.example.name
#   publisher_name      = "${local.apim_publisher_name}"
#   publisher_email     = "${local.apim_publisher_email}"

#   sku_name = "Developer_1" # ¥7,013.69/月
#   #sku_name = "Basic" # ¥21,488.74/月
#   #sku_name = "Standard" # ¥100,270.11/月
#   #sku_name = "Premium" #¥408,136.76/月
# }

################################################################################
# redis cache
# resource "azurerm_redis_cache" "example" {
#   name                = "${local.redis_cache_name}"
#   location            = azurerm_resource_group.example.location
#   resource_group_name = azurerm_resource_group.example.name
#   capacity            = 0
#   family              = "C"
#   # sku_name            = "Basic"  
#   sku_name            = "Standard"
#   # Basic C0 250M ¥2,345.001/月
#   # Basic C1 1GB ¥5,862.503/月
#   # Basic C2 2.5GB ¥9,593.186/月
#   # Basic C3 6GB ¥19,186.372/月
#   # Basic C4 13GB ¥22,384.100/月
#   # Standard C0 250M ¥5,862.503/月
#   # Standard C1 1GM ¥14,709.552/月
#   # Premium 6GB P1 ¥59,051.387/月
#   # Premium 12GB P2 ¥118,315.956/月
#   enable_non_ssl_port = false
#   minimum_tls_version = "1.2"

#   redis_version = 6

#   redis_configuration {
#   }
# }


################################################################################
# web pub/sub (websocket)
# resource "azurerm_web_pubsub" "example" {
#   name                = "${local.web_pubsub_name}"
#   location            = azurerm_resource_group.example.location
#   resource_group_name = azurerm_resource_group.example.name

#   sku      = "Standard_S1"
#   capacity = 1

#   public_network_access_enabled = true
#   #public_network_access_enabled = flase

#   live_trace {
#     enabled                   = true
#     messaging_logs_enabled    = true
#     connectivity_logs_enabled = false
#   }
# }

################################################################################
# iot hub


################################################################################
# sql server
# resource "azurerm_mssql_server" "example" {
#   name                         = "${local.sqlsrv_server_name}"
#   resource_group_name          = azurerm_resource_group.example.name
#   location                     = azurerm_resource_group.example.location
#   version                      = "12.0"
#   administrator_login          = "${local.sqlsrv_server_admin_name}"
#   administrator_login_password = "${local.sqlsrv_server_admin_pass}"
# }

# resource "azurerm_mssql_database" "test" {
#   name           = "${local.sqlsrv_db_name1}"
#   server_id      = azurerm_mssql_server.example.id
#   collation      = "Japanese_CS_AS_KS_WS"
#   license_type   = "LicenseIncluded"
#   # max_size_gb    = 4
#   # read_scale     = true
#   # sku_name       = "S0"
#   # zone_redundant = true
# }

################################################################################
# mysql server (single)
# resource "azurerm_mysql_server" "example" {
#   name                = "${local.mysql_single_server_name}"
#   location            = azurerm_resource_group.example.location
#   resource_group_name = azurerm_resource_group.example.name

#   administrator_login          = "${local.mysql_single_admin_name}"
#   administrator_login_password = "${local.mysql_single_admin_password}"

#   sku_name   = "B_Gen5_2"
#   storage_mb = 5120
#   version    = "5.7"

#   auto_grow_enabled                 = true
#   backup_retention_days             = 7
#   geo_redundant_backup_enabled      = false
#   infrastructure_encryption_enabled = false
#   public_network_access_enabled     = true
#   ssl_enforcement_enabled           = true
#   ssl_minimal_tls_version_enforced  = "TLS1_2"
# }
# # allow access Azure service
# resource "azurerm_mysql_firewall_rule" "example" {
#   name                = "allow-azureservice"
#   resource_group_name = azurerm_resource_group.example.name
#   server_name         = azurerm_mysql_server.example.name
#   start_ip_address    = "0.0.0.0"
#   end_ip_address      = "0.0.0.0"
# }
# # allow dev user env
# resource "azurerm_mysql_firewall_rule" "example2" {
#   name                = "dev-user1"
#   resource_group_name = azurerm_resource_group.example.name
#   server_name         = azurerm_mysql_server.example.name
#   start_ip_address    = "14.132.153.117"
#   end_ip_address      = "14.132.153.117"
# }

################################################################################
# mysql flexible server
resource "azurerm_mysql_flexible_server" "example" {
  name                   = "${local.mysql_server_name}"
  resource_group_name    = azurerm_resource_group.example.name
  location               = azurerm_resource_group.example.location
  administrator_login    = "${local.mysql_admin_name}"
  administrator_password = "${local.mysql_admin_password}"
  sku_name               = "B_Standard_B1s" # ¥1,372.112/月
  #sku_name               = "B_Standard_B1ms" # ¥2,744.224/月  
  #sku_name               = "B_Standard_B2s" # ¥10,976.894/月
  #sku_name               = "B_Standard_B2ms" # ¥21,953.787/月      
  version                = "8.0.21" # or 5.7
  zone                   = 2
}
# allow access Azure service
resource "azurerm_mysql_flexible_server_firewall_rule" "example" {
  name                = "allow-azureservice-fs"
  resource_group_name = azurerm_resource_group.example.name
  server_name         = azurerm_mysql_flexible_server.example.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}
# allow dev user env
resource "azurerm_mysql_flexible_server_firewall_rule" "example2" {
  name                = "dev-user1"
  resource_group_name = azurerm_resource_group.example.name
  server_name         = azurerm_mysql_flexible_server.example.name
  start_ip_address    = "14.132.153.117"
  end_ip_address      = "14.132.153.117"
}

resource "azurerm_mysql_flexible_database" "example" {
  name                = "${local.mysql_dbname1}"
  resource_group_name = azurerm_resource_group.example.name
  server_name         = azurerm_mysql_flexible_server.example.name
  charset             = "utf8mb4" #日本語いれるならこちら 4バイトのutf8
  collation           = "utf8mb4_general_ci"
}

resource "azurerm_mysql_flexible_database" "example2" {
  name                = "${local.mysql_dbname2}"
  resource_group_name = azurerm_resource_group.example.name
  server_name         = azurerm_mysql_flexible_server.example.name
  charset             = "utf8mb4"
  collation           = "utf8mb4_general_ci"
}

################################################################################
# cognitive search  (full text search)
# resource "azurerm_search_service" "example" {
#   name                = "${local.cognitive_search_name}"
#   resource_group_name = azurerm_resource_group.example.name
#   location            = azurerm_resource_group.example.location
#   sku                 = "basic"
#   # free 50MB
#   # basic 2GB $75
#   # standard 50GB $250
#   # standard2 100GB $1000
#   # standard3 200GB $2000
#   # L1 1TB $2900
#   # L2 2TB $5800
# }

# static web apps
resource "azurerm_static_site" "example" {
  name                = "${local.static_web_app_name}"
  resource_group_name = azurerm_resource_group.example.name
  location            = "eastasia"
  sku_size            = "Standard"
}

# app service plan (linux)
resource "azurerm_service_plan" "example" {
  name                = "${local.appservice_plan_name}"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  os_type             = "Linux"
  sku_name            = "P1v2"
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
  
  #ステートフルアプリの為 セッションアフィニティを ON
  client_affinity_enabled = true

  identity {
    #システム割り当てマネージド ID　を利用します
    type = "SystemAssigned"
  }

  site_config {
    app_command_line = "az-appsrv-startup.sh"
    application_stack {
      python_version = "3.9"
      #python_version = "3.9"      
    }
  }

  app_settings = {
    # # key valueから設定する
    # # @Microsoft.KeyVault(SecretUri=https://yelpcamp-example-kv.vault.azure.net/secrets/ExamplePassword)
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

resource "azurerm_linux_web_app_slot" "example" {
  name           = "dev1"
  app_service_id = azurerm_linux_web_app.example.id

  site_config {}
}
resource "azurerm_linux_web_app_slot" "example1" {
  name           = "dev2"
  app_service_id = azurerm_linux_web_app.example.id

  site_config {}
}
resource "azurerm_linux_web_app_slot" "example2" {
  name           = "dev3"
  app_service_id = azurerm_linux_web_app.example.id

  site_config {}
}


# app service の診断設定
resource "azurerm_monitor_diagnostic_setting" "example" {
  name               = "example-diag-log"
  target_resource_id = azurerm_linux_web_app.example.id
  #storage_account_id = data.azurerm_storage_account.example.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.example.id

  log {
    category = "AppServiceHTTPLogs"
    enabled  = true

    retention_policy {
      enabled = false
    }
  }

  log {
    category = "AppServiceConsoleLogs"
    enabled  = true

    retention_policy {
      enabled = false
    }
  }

  metric {
    category = "AllMetrics"

    retention_policy {
      enabled = false
    }
  }
}

resource "azurerm_linux_web_app" "example4" {
  name                = "${local.appservice_name_dev}"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  service_plan_id     = azurerm_service_plan.example.id
  https_only            = true
  
  #ステートフルアプリの為 セッションアフィニティを ON
  client_affinity_enabled = true

  identity {
    #システム割り当てマネージド ID　を利用します
    type = "SystemAssigned"
  }

  site_config {
    app_command_line = "az-appsrv-startup.sh"
    application_stack {
      python_version = "3.9"
    }
  }

  app_settings = {
    # # key valueから設定する
    # # @Microsoft.KeyVault(SecretUri=https://example-kv-6650.vault.azure.net/secrets/MyKeyVaultTestValue/xxx)
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

# app service の診断設定
resource "azurerm_monitor_diagnostic_setting" "example4" {
  name               = "example-diag-log"
  target_resource_id = azurerm_linux_web_app.example4.id
  #storage_account_id = data.azurerm_storage_account.example.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.example.id

  log {
    category = "AppServiceHTTPLogs"
    enabled  = true

    retention_policy {
      enabled = false
    }
  }

  log {
    category = "AppServiceConsoleLogs"
    enabled  = true

    retention_policy {
      enabled = false
    }
  }

  metric {
    category = "AllMetrics"

    retention_policy {
      enabled = false
    }
  }
}

resource "azurerm_linux_web_app" "example2" {
  name                = "${local.appservice_name2}"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  service_plan_id     = azurerm_service_plan.example.id
  https_only            = true

  #ステートフルアプリの為 セッションアフィニティを ON
  #client_affinity_enabled = true

  identity {
    #システム割り当てマネージド ID　を利用します
    type = "SystemAssigned"
  }

  site_config {
    application_stack {
      #python_version = "3.9"
      #node_version = "14-lts"
      node_version = "16-lts"
      #node_version = "18-lts"
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
    #WEBSITE_RUN_FROM_PACKAGE = "1"
  }  
}

# resource "azurerm_linux_web_app" "example3" {
#   name                = "${local.appservice_name3}"
#   location            = azurerm_resource_group.example.location
#   resource_group_name = azurerm_resource_group.example.name
#   service_plan_id     = azurerm_service_plan.example.id
#   https_only            = true

#   identity {
#     #システム割り当てマネージド ID　を利用します
#     type = "SystemAssigned"
#   }

#   site_config {
#     application_stack {
#       docker_image = "kytp03cr.azurecr.io/kytool"
#       docker_image_tag = "ver1.4.0.d2"
#     }
#   }

#   app_settings = {
#     # # key valueから設定する
#     # # @Microsoft.KeyVault(SecretUri=https://yelpcamp-example-kv.vault.azure.net//secrets/ExamplePassword/xxx)
#     # # db connection string (DB_URL)
#     # DB_URL = "@Microsoft.KeyVault(SecretUri=${azurerm_key_vault_secret.example.id})"
#     # # external api key (MAPBOX_TOKEN)
#     # MAPBOX_TOKEN = "@Microsoft.KeyVault(SecretUri=${azurerm_key_vault_secret.example2.id})"
#     #デプロイ時にソースを自動ビルドするかどうか
#     #デプロイ時にソースを自動ビルドを実施する仕組み (Oryx) 
#     #SCM_DO_BUILD_DURING_DEPLOYMENT = "true"
#     #ENABLE_ORYX_BUILD = "true"
#   } 
# }

# resource "azurerm_linux_web_app" "example-spa" {
#   name                = "${local.appservice_spa_name}"
#   location            = azurerm_resource_group.example.location
#   resource_group_name = azurerm_resource_group.example.name
#   service_plan_id     = azurerm_service_plan.example.id
#   https_only            = true

#   identity {
#     #システム割り当てマネージド ID　を利用します
#     type = "SystemAssigned"
#   }

#   site_config {
#   }
# }

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

################################################################################
# azure blob storage spa webホスティング用
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
resource "azurerm_storage_account" "example2" {
  name                     = "${local.storage_ac_name1}"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
}
resource "azurerm_storage_account" "example3" {
  name                     = "${local.storage_ac_name2}"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
}

################################################################################
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
    FUNCTIONS_WORKER_RUNTIME= "python"
    FUNCTIONS_EXTENSION_VERSION = "~4"
  }

  site_config {
    application_stack {
      python_version = "3.9"
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
      python_version = "3.9"
    }
  }
}

resource "azurerm_storage_account" "example4func3" {
  name                     = "${local.func_storage_name3}"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
resource "azurerm_linux_function_app" "example3" {
  name                = "${local.func_app_name3}"
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
      python_version = "3.9"
    }
  }
}

resource "azurerm_storage_account" "example4func4" {
  name                     = "${local.func_storage_name4}"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
resource "azurerm_linux_function_app" "example4" {
  name                = "${local.func_app_name4}"
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
      python_version = "3.9"
    }
  }
}

resource "azurerm_storage_account" "example4func5" {
  name                     = "${local.func_storage_name5}"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
resource "azurerm_linux_function_app" "example5" {
  name                = "${local.func_app_name5}"
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


resource "azurerm_api_management" "example" {
  name                = "${local.apim_name}"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  publisher_name      = "${local.apim_publisher_name}"
  publisher_email     = "${local.apim_publisher_email}"

  sku_name = "Developer_1"
}
