resource "azurerm_role_assignment" "acrpull_role" {
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  
  # agentpool (ユーザー割り当てマネージドID)
  principal_id         = azurerm_kubernetes_cluster.example.kubelet_identity[0].object_id

  # Necessary to prevent unnecessary redeployment  
  lifecycle {
    ignore_changes = [
      name
    ]
  }
}
