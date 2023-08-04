resource "kubectl_manifest" "wayfinder_cloudidentity_main" {
  count = var.enable_k8s_resources ? 1 : 0

  depends_on = [
    helm_release.wayfinder,
  ]

  yaml_body = templatefile("${path.module}/manifests/wayfinder-cloudidentity.yml.tpl", {
    name                 = "cloudidentity-azure"
    description          = "Cloud managed identity"
    implicit_identity_id = azurerm_user_assigned_identity.wayfinder_main.client_id
  })
}

resource "kubectl_manifest" "wayfinder_cloudidentity_cloudinfo" {
  count = var.enable_k8s_resources ? 1 : 0

  depends_on = [
    helm_release.wayfinder,
  ]

  yaml_body = templatefile("${path.module}/manifests/wayfinder-cloudidentity.yml.tpl", {
    name                 = "azure-admin-cloudinfo"
    description          = "Role identity for Cost Estimates"
    implicit_identity_id = azurerm_user_assigned_identity.wayfinder_cloud_info.client_id
  })
}

resource "kubectl_manifest" "wayfinder_cloudidentity_dnszonemanager" {
  count = var.enable_k8s_resources ? 1 : 0

  depends_on = [
    helm_release.wayfinder,
  ]

  yaml_body = templatefile("${path.module}/manifests/wayfinder-cloudidentity.yml.tpl", {
    name                 = "azure-admin-dnszonemanager"
    description          = "Role identity for DNS Zone Management"
    implicit_identity_id = azurerm_user_assigned_identity.wayfinder_dns_zone_manager.client_id
  })
}

resource "kubectl_manifest" "wayfinder_cloudidentity_none" {
  count = var.enable_k8s_resources ? 1 : 0

  depends_on = [
    helm_release.wayfinder,
  ]

  yaml_body = templatefile("${path.module}/manifests/wayfinder-cloudidentity.yml.tpl", {
    name                 = "azure-admin-none"
    description          = "Role identity for Minimum Access"
    implicit_identity_id = azurerm_user_assigned_identity.wayfinder_none.client_id
  })
}
