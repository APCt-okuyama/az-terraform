variable "rg_name" {}
variable "rg_name_service" {}
variable "location" {
  default = "japaneast"
}

variable "projectno" {
}

variable "vnet_id" {}
variable "subnet_id_pl" {}

variable "psql_admin_user" {
  default = "psqladmin"
}

variable "psql_admin_password" {
  default = "P@ssword"
  sensitive = true
}

variable "psql_database_name" {
  default = "app"
}

variable "pdnsz_name" {
  default = "privatelink.postgres.database.azure.com"
}