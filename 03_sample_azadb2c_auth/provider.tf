terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
  backend "azurerm" {
    resource_group_name  = "b-team-rg"
    storage_account_name = "tfstate10310"
    container_name       = "tfstate-b2csample"
    # 環境変数 (ARM_ACCESS_KEY) が利用されます。
    key                  = "terraform.tfstate"
  }
}
provider "azurerm" {
  features {
    resource_group {
      # ad b2cにユーザーなどが登録されていても削除を実行
      prevent_deletion_if_contains_resources = false
    }
  }
}
