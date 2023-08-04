resource "azurerm_user_assigned_identity" "cert_manager" {
  location            = var.location
  resource_group_name = module.aks.node_resource_group
  name                = "wf-admin-cert-manager-${local.wayfinder_instance_id}"
  tags                = var.tags
}

resource "azurerm_role_assignment" "cert_manager_dns_contributor" {
  scope                = var.dns_zone_id
  role_definition_name = "DNS Zone Contributor"
  principal_id         = azurerm_user_assigned_identity.cert_manager.principal_id
}

resource "azurerm_federated_identity_credential" "cert_manager" {
  name                = azurerm_user_assigned_identity.cert_manager.name
  resource_group_name = azurerm_user_assigned_identity.cert_manager.resource_group_name
  parent_id           = azurerm_user_assigned_identity.cert_manager.id
  audience            = ["api://AzureADTokenExchange"]
  issuer              = module.aks.oidc_issuer_url
  subject             = "system:serviceaccount:cert-manager:cert-manager"
}

resource "helm_release" "cert_manager" {
  count = var.enable_k8s_resources ? 1 : 0

  depends_on = [
    module.aks,
  ]

  namespace        = "cert-manager"
  create_namespace = true

  name        = "cert-manager"
  repository  = "https://charts.jetstack.io"
  chart       = "cert-manager"
  version     = "v1.11.0"
  max_history = 5

  values = [templatefile("${path.module}/manifests/cert-manager-values.yml.tpl", {})]
}

resource "kubectl_manifest" "cert_manager_clusterissuer" {
  count = var.enable_k8s_resources ? 1 : 0

  depends_on = [
    module.aks,
    helm_release.cert_manager,
  ]

  yaml_body = templatefile("${path.module}/manifests/cert-manager-clusterissuer.yml.tpl", {
    email              = var.clusterissuer_email
    dns_zone_name      = var.dns_zone_name
    resource_group     = var.resource_group_name
    subscription_id    = data.azurerm_subscription.current.subscription_id
    identity_client_id = azurerm_user_assigned_identity.cert_manager.client_id
  })
}
