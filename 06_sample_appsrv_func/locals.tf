# ローカル変数
# project name
resource "random_string" "projectno" {
  length = 4
  upper   = false
  lower   = false
  numeric  = true
  special = false  
}

# 関数や他リソースの参照などが利用可能
locals {
  # resource group
  rg_name = "s-product-oku-${random_string.projectno.result}"
  location = "japaneast"
  
  # app insights
  ws_name = "logw-${random_string.projectno.result}"
  ai_name = "app-insights-${random_string.projectno.result}"

  # vnet
  vnet_name = "vnet-example-${random_string.projectno.result}"
  snet_name = "internal-${random_string.projectno.result}"
  # acr
  acr_name = "exampleacr${random_string.projectno.result}"

  # ad b2c
  ad_b2c_name = "example-b2c-tenant-${random_string.projectno.result}"
  ad_b2c_domain_name = "exampleb2ctenant${random_string.projectno.result}.onmicrosoft.com"

  # key vault
  keyvault_name = "example-kv-${random_string.projectno.result}"
  
  # ms sql server server
  sqlsrv_server_name = "mssql-server-${random_string.projectno.result}"
  sqlsrv_server_admin_name = "mssqladmin"
  sqlsrv_server_admin_pass = "@PC0mmun!cat!0ns"
  sqlsrv_db_name1 = "exampledb1"

  # mysql flexible server
  mysql_server_name = "mysql-fs-${random_string.projectno.result}"
  mysql_admin_name = "mysqladmin"
  mysql_admin_password = "@PC0mmun!cat!0ns"
  mysql_dbname1 = "spectadb_apcdev"
  mysql_dbname2 = "myexampledb2"

  # mysql single server (example-textsearch)
  mysql_single_server_name = "example-textsearch"
  mysql_single_admin_name = "mysqladmin"
  mysql_single_admin_password = "@PC0mmun!cat!0ns"

  # mysql firewall
  

  # cosmos
  # cosmos_account_name = "cosmos-account-${random_string.projectno.result}"
  # cosmos_db_name = "cosmos-db-${random_string.projectno.result}"  

  # cognitive search
  cognitive_search_name = "cognitive-search-${random_string.projectno.result}"
  
  # static web app
  static_web_app_name = "swa-${random_string.projectno.result}"

  # app service
  appservice_plan_name = "appsrv-plan-${random_string.projectno.result}"
  appservice_name = "appsrv-sampleapp-py-${random_string.projectno.result}"  
  appservice_name2 = "appsrv-sampleapp-node-${random_string.projectno.result}"
  appservice_name3 = "appsrv-sampleapp-container-${random_string.projectno.result}"
  appservice_name_dev = "appsrv-sampleapp-py2-${random_string.projectno.result}"
  appservice_spa_name = "appsrv-sample-spa-${random_string.projectno.result}"
  
  # azure storage (for product)
  storage_ac_name1 = "sproduct001storage${random_string.projectno.result}"
  storage_ac_name2 = "sproduct002storage${random_string.projectno.result}"

  # azure storage blob (for spa)
  blob_storage_ac_name = "examplestorageacc${random_string.projectno.result}"
  spa_container_name = "spa-container-${random_string.projectno.result}"  
  spa_index_document_name = "index.html"

  # functions
  func_plan_name1 = "func-plan1-${random_string.projectno.result}"

  func_storage_name1 = "funcstorage${random_string.projectno.result}"
  func_app_name1 = "func-app1-${random_string.projectno.result}"

  func_storage_name2 = "func2storage${random_string.projectno.result}"
  func_app_name2 = "func-app2-${random_string.projectno.result}"

  func_storage_name3 = "func3storage${random_string.projectno.result}"
  func_app_name3 = "func-app3-${random_string.projectno.result}"

  func_storage_name4 = "func4storage${random_string.projectno.result}"
  func_app_name4 = "func-app4-${random_string.projectno.result}"

  func_storage_name5 = "func5storage${random_string.projectno.result}"
  func_app_name5 = "func-app5-node-${random_string.projectno.result}"

  # api management
  apim_name = "apim${random_string.projectno.result}"
  apim_publisher_name = "t_okuyama"
  apim_publisher_email = "t_okuyama@ap-com.co.jp" 

  # redis cache
  redis_cache_name = "redis-cache-${random_string.projectno.result}"

  # web pub/sub
  web_pubsub_name = "pubsub-${random_string.projectno.result}"
}
