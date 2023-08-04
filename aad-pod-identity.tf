resource "azurerm_role_assignment" "aadpi_virtual_machine_contributor" {
  scope                = "${data.azurerm_subscription.current.id}/resourceGroups/${module.aks.node_resource_group}"
  role_definition_name = "Virtual Machine Contributor"
  principal_id         = module.aks.kubelet_identity[0].object_id
}

resource "azurerm_role_assignment" "aadpi_managed_identity_operator" {
  scope                = "${data.azurerm_subscription.current.id}/resourceGroups/${module.aks.node_resource_group}"
  role_definition_name = "Managed Identity Operator"
  principal_id         = module.aks.kubelet_identity[0].object_id
}

resource "helm_release" "aad_pod_identity" {
  count = var.enable_k8s_resources ? 1 : 0

  depends_on = [
    azurerm_role_assignment.aadpi_virtual_machine_contributor,
    azurerm_role_assignment.aadpi_managed_identity_operator
  ]

  namespace        = "kube-system"
  create_namespace = false

  name       = "aad-pod-identity"
  repository = "https://raw.githubusercontent.com/Azure/aad-pod-identity/master/charts/"
  chart      = "aad-pod-identity"
  version    = "4.1.18"

  set {
    name  = "forceNamespaced"
    value = "true"
  }
}
