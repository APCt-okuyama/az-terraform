# IaC(terraform) で Azureリソースを構築する

この環境(赤枠の部分)をterraformで実装する例
![image](../deployToAppService.png)

## (Option) 本番や実践的な運用にむけて


Terraformの状態(terraform.tfstate) は 既定ではローカルに格納されますが次の理由から理想的ではない。
・ローカルの状態は、チーム環境または共同作業環境ではあまり実用的でない。
・Terraform 状態に機密情報が含まれる可能性がある。
・状態をローカルに格納すると、不注意で削除される可能性が高くなる。

[こちらの手順](https://learn.microsoft.com/ja-jp/azure/developer/terraform/store-state-in-azure-storage?tabs=azure-cli)に従って Terraformの状態(terraform.tfstate) をリモートで管理することを検証しましょう。

## 作成する Azure リーソース
・Resource Group
・AD B2C テナント
・Key Vault
・Container Registory (acr)

・AppService x 2
・Functions x 2
・Storage (web用)
・API Management

## ファイル構成
```
tree
.
├── .gitignore # terraform用の.gitignore
├── README.md
├── locals.tf
├── main.tf
├── output.tf
├── provider.tf
├── sample-terraform-docs.md # terraform-docsで作成された Document(Markdown形式)
├── terraform.tfstate
├── terraform.tfstate.backup
└── variables.tf
```
※ terraform用の.gitignore は https://github.com/github/gitignore/blob/main/Terraform.gitignore を利用。

## terraformコマンド実行
※ tfenvをいれておく
```
tfenv install 1.2.2
tfenv list
tfenv use 1.2.2
```

```
terraform -version
Terraform v1.2.2
on linux_amd64
```

## init, plan, apply, destory

Terraformの状態(terraform.tfstate) をリモートで管理している場合は、ストレージアカウントのアクセスキーが必要。環境変数に設定する。
```
export ARM_ACCESS_KEY=<ストレージアカウントのアクセスキー>
```

```
terraform init
terraform plan
terraform apply
terraform apply -auto-approve
terraform destory
```

## input variable と locals

どちらを利用する？　基本的には 内部の変数は locals を利用する。他のモジュールに値を渡したい場合は variable を利用する。

| variable | locals |
| --- | --- |
| 関数が利用できない | 関数が利用できる |
| 外部から値を設定・上書きできる<br>実行時にファイル・環境変数・オプション・対話的入力など。 | 外部から値を設定・上書きできない |
| ... | ... |

## 例: 秘匿情報 (パスワードなど)
外部APIのToken情報など外部からの値を利用したい場合。
環境変数が簡単に利用できて良い。prefixにTF_VAR_をつけるとterraform側で参照できます。

環境変数を定義 (TF_VAR_xxxxx) 
```
export TF_VAR_mapboxapitoken=xxxxtokentokenxxxx
```

variables.tf に同じ名前で変数を定義
```
variable "mapboxapitoken" {
    description = "mapbox api token"
    type = string
    sensitive = true
}
```

main.tf で利用する (var.xxxxx)
```
# MAPBOX_TOKEN を設定
resource "azurerm_key_vault_secret" "example2" {
  name         = "MAPBOXTOKEN"
  value        = var.mapboxapitoken
  key_vault_id = azurerm_key_vault.example.id
}
```

## document (terraform-docs)

ドキュメント生成する為のツール(terraform-docs)があります。

```
cd infra
/usr/local/terraform-docs markdown table --output-file sample-terraform-docs.md --output-mode inject ./
```
