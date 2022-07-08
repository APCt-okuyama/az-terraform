# "${random_string.default.result}"
resource "random_string" "projectno" {
  length = 8
  upper   = false
  lower   = false
  numeric  = true
  special = false  
}

# 共通 vnetなど

module "common" {
    source = "./common"
    projectno = random_string.projectno.result    
}

# db
module "db" {
    source = "./db"
    projectno = random_string.projectno.result

    # commonのoutputを渡す
    location = module.common.rg_common_location
    rg_name = module.common.rg_common_name
    rg_name_service = module.common.rg_service_name    
    vnet_id = module.common.vnet_id
    subnet_id_pl = module.common.subnet_id_pl
}

# aks acr
module "aks" {
    source = "./aks"
    projectno = random_string.projectno.result

    location = module.common.rg_common_location
    rg_name = module.common.rg_common_name
    rg_name_service = module.common.rg_service_name    
    vnet_id = module.common.vnet_id
    subnet_id_aks = module.common.subnet_id_aks

    # depends_onの利用例
    # 削除(destory)するときにaksからdbへアクセスしているとdbが削除できない
    # depends_onを指定してあげるとaksから先に削除する
    depends_on = [
      module.db
    ]
}