resource "azurerm_user_assigned_identity" "external_dns" {
  location            = var.location
  resource_group_name = module.aks.node_resource_group
  name                = "wf-admin-external-dns-${var.wayfinder_instance_id}"
  tags                = var.tags
}

resource "azurerm_role_assignment" "external_dns_dns_contributor" {
  scope                = var.dns_zone_id
  role_definition_name = var.dns_provider == "azure-private-dns" ? "Private DNS Zone Contributor" : "DNS Zone Contributor"
  principal_id         = azurerm_user_assigned_identity.external_dns.principal_id
}

resource "azurerm_role_assignment" "external_dns_reader" {
  scope                = local.dns_resource_group_id
  role_definition_name = "Reader"
  principal_id         = azurerm_user_assigned_identity.external_dns.principal_id
}

resource "azurerm_federated_identity_credential" "external_dns" {
  name                = azurerm_user_assigned_identity.external_dns.name
  resource_group_name = azurerm_user_assigned_identity.external_dns.resource_group_name
  parent_id           = azurerm_user_assigned_identity.external_dns.id
  audience            = ["api://AzureADTokenExchange"]
  issuer              = module.aks.oidc_issuer_url
  subject             = "system:serviceaccount:external-dns:external-dns"
}

resource "helm_release" "external_dns" {
  count = var.enable_k8s_resources ? 1 : 0

  depends_on = [
    module.aks,
  ]

  namespace        = "external-dns"
  create_namespace = true

  name        = "external-dns"
  repository  = "https://kubernetes-sigs.github.io/external-dns"
  chart       = "external-dns"
  version     = "1.13.1"
  max_history = 5

  values = [
    templatefile("${path.module}/manifests/external-dns-values.yml.tpl", {
      resource_group  = var.resource_group_name
      client_id       = azurerm_user_assigned_identity.external_dns.client_id
      tenant_id       = data.azurerm_subscription.current.tenant_id
      subscription_id = data.azurerm_subscription.current.subscription_id
      dns_provider    = var.dns_provider
    })
  ]
}
