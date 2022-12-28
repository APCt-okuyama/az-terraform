# ローカル変数
# project name
resource "random_string" "projectno" {
  length = 5
  upper   = false
  lower   = false
  numeric  = true
  special = false  
}

# 関数や他リソースの参照などが利用可能
locals {
  # resource group
  rg_name = "oku-example-${random_string.projectno.result}"
  location = "japaneast"
  
  # acr
  acr_name = "exampleacr${random_string.projectno.result}"

  # ad b2c
  # ad_b2c_name = "example-b2c-tenant-${random_string.projectno.result}"
  # ad_b2c_domain_name = "exampleb2ctenant${random_string.projectno.result}.onmicrosoft.com"

  # key vault
  keyvault_name = "example-kv-${random_string.projectno.result}"

  # # cosmos
  # cosmos_account_name = "cosmos-account-${random_string.projectno.result}"
  # cosmos_db_name = "cosmos-db-${random_string.projectno.result}"  

  # app service
  appservice_plan_name = "appsrv-plan-${random_string.projectno.result}"
  appservice_name = "appsrv-sampleapp-${random_string.projectno.result}"
  appservice_spa_name = "appsrv-sample-spa-${random_string.projectno.result}"

  # azure storage blob
  blob_storage_ac_name = "examplestorageacc${random_string.projectno.result}"
  spa_container_name = "spa-container-${random_string.projectno.result}"  
  spa_index_document_name = "index.html"

  # functions
  func_plan_name1 = "func-plan1-${random_string.projectno.result}"
  func_storage_name1 = "funcstorage${random_string.projectno.result}"
  func_app_name1 = "func-app1-${random_string.projectno.result}"
  func_storage_name2 = "func2storage${random_string.projectno.result}"
  func_app_name2 = "func-app2-${random_string.projectno.result}"

  # api management
  # apim_name = "apim${random_string.projectno.result}"
  # apim_publisher_name = "taro"
  # apim_publisher_email = "taro@example.co.jp" 

  mysql_server_name = "example-mysqlserver-${random_string.projectno.result}"
  mysql_admin_user = "apcsqladmin"
  mysql_admin_password = "apc@123456789"  
  mysql_db_name1 = "exampledb01"
}
