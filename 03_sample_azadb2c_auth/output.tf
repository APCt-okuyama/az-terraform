output "output-message" {
  description = "これはサンプル"
  # deploy コマンドの例
  value       = "これはサンプル terraform apply後に表示したいメッセージを追加できます"
}

output "output-message1" {
  description = "app service へのデプロイ用の azコマンド のサンプルを出力"
  # deploy コマンドの例
  value       = "(app service): az webapp up -n ${local.appservice_name} -g ${local.rg_name} -p ${local.appservice_plan_name} -l ${local.location}"
}

output "output-message2" {
  description = "functions へのデプロイ用の azコマンド のサンプルが出力されます"
  # deploy コマンドの例
  value       = "(Functions) func azure functionapp publish ${local.func_app_name1}"
}

output "output-message3" {
  description = "spa を azure storage へデプロイ"
  # deploy コマンドの例
  value       = "(spa to blob storage): az storage blob upload-batch -s dist -d '$web' --account-name ${local.blob_storage_ac_name} --overwrite"
}