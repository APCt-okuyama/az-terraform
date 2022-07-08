variable "projectno" {
}

variable "author" {
    default = "okuyama"
}

variable "location" {
    default = "japaneast"
}

variable "vnet_address_space" {
    default = ["10.1.0.0/16", "10.2.0.0/16"]
}

variable "subnet_aks_name" {
    default = "snet-aks"
}

variable "subnet_aks_address_prefixes" {
    default = ["10.1.0.0/16"]
}

variable "subnet_pl_name" {
    default = "snet-pl"
}

variable "subnet_pl_address_prefixes" {
    default = ["10.2.0.0/24"]
}

variable "subnet_agw_name" {
    default = "snet-agw"
}

variable "subnet_agw_address_prefixes" {
    default = ["10.2.1.0/24"]
}
