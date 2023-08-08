provider "azurerm" {
  features {}
}

provider "helm" {
  kubernetes {
    client_certificate     = base64decode(module.wayfinder.aks_client_certificate)
    client_key             = base64decode(module.wayfinder.aks_client_key)
    cluster_ca_certificate = base64decode(module.wayfinder.aks_cluster_ca_certificate)
    host                   = module.wayfinder.aks_host
  }
}

provider "kubectl" {
  client_certificate     = base64decode(module.wayfinder.aks_client_certificate)
  client_key             = base64decode(module.wayfinder.aks_client_key)
  cluster_ca_certificate = base64decode(module.wayfinder.aks_cluster_ca_certificate)
  host                   = module.wayfinder.aks_host
  load_config_file       = false
}
