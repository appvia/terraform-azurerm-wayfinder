resource "azurerm_public_ip" "ingress" {
  count = !var.disable_internet_access ? 1 : 0

  name                = "${local.name}-ingress-pip01"
  resource_group_name = module.aks.node_resource_group
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

resource "helm_release" "ingress" {
  count = var.enable_k8s_resources ? 1 : 0

  depends_on = [
    module.aks,
  ]

  namespace        = "ingress-nginx"
  create_namespace = true

  name        = "ingress-nginx"
  repository  = "https://kubernetes.github.io/ingress-nginx"
  chart       = "ingress-nginx"
  version     = "4.11.2"
  max_history = 5

  values = [
    templatefile("${path.module}/manifests/ingress-values.yml.tpl", {
      node_resource_group     = module.aks.node_resource_group
      disable_internet_access = tostring(var.disable_internet_access)
      ingress_ip_address      = !var.disable_internet_access ? azurerm_public_ip.ingress[0].ip_address : ""
    })
  ]
}
