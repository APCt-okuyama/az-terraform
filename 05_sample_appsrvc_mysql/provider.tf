terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
  backend "azurerm" {
    # 前もってAzure Storage Accountの作成が必要
    # RESOURCE_GROUP_NAME=tfstate
    # STORAGE_ACCOUNT_NAME=tfstate$RANDOM
    # CONTAINER_NAME=tfstate
    # az group create --name $RESOURCE_GROUP_NAME --location japaneast
    # az storage account create --resource-group $RESOURCE_GROUP_NAME --name $STORAGE_ACCOUNT_NAME --sku Standard_LRS --encryption-services blob
    # az storage container create --account-name $STORAGE_ACCOUNT_NAME --name $CONTAINER_NAME
    # ACCOUNT_KEY=$(az storage account keys list --resource-group $RESOURCE_GROUP_NAME --account-name $STORAGE_ACCOUNT_NAME --query '[0].value' -o tsv)
    # 環境変数 (ARM_ACCESS_KEY) が利用されます。
    # export ARM_ACCESS_KEY=$ACCOUNT_KEY    
    resource_group_name  = "b-team-rg"
    storage_account_name = "tfstateappserviceexample"
    container_name       = "tfstate-appsrvc-mysql"
    key                  = "terraform.tfstate"
  }
}
provider "azurerm" {
  features {
    resource_group {
      # ad b2cにユーザーなどが登録されていても削除を実行
      #prevent_deletion_if_contains_resources = false
    }
  }
}
