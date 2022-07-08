# AKS
resource "azurerm_kubernetes_cluster" "example" {
  name                = local.aks_name
  location            = var.location
  resource_group_name = var.rg_name_service
  dns_prefix          = local.aks_name

  default_node_pool {
    name       = "default"
    node_count = var.node_count
    vm_size    = var.vm_size
    vnet_subnet_id = var.subnet_id_aks
  }

  # Network は Azure CNI
  network_profile {
    network_plugin    = "azure"
    load_balancer_sku = "standard"
  }

  identity {
    type = "SystemAssigned"
  }
}