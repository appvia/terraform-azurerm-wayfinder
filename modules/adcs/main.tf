resource "helm_release" "adcs_issuer" {
  namespace        = "adcs-issuer"
  create_namespace = true

  name        = "adcs-issuer"
  repository  = "https://djkormo.github.io/adcs-issuer/"
  chart       = "adcs-issuer"
  version     = "2.1.1"
  max_history = 5

  set {
    name  = "simulator.enabled"
    value = "false"
  }

  set {
    name  = "simulator.exampleCertificate.enabled"
    value = "false"
  }
}

resource "kubectl_manifest" "adcs_credentials_secret" {
  depends_on = [helm_release.adcs_issuer]

  yaml_body = <<YAML
apiVersion: v1
kind: Secret
type: Opaque
metadata:
  name: adcs-issuer-credentials
  namespace: adcs-issuer
stringData:
  username: ${var.username}
  password: ${var.password}
YAML
}

resource "kubectl_manifest" "adcs_cluster_issuer" {
  depends_on = [kubectl_manifest.adcs_credentials_secret]

  yaml_body = <<YAML
apiVersion: adcs.certmanager.csf.nokia.com/v1
kind: ClusterAdcsIssuer
metadata:
  name: adcs-issuer
spec:
  caBundle: ${var.adcs_ca_bundle}
  credentialsRef:
    name: adcs-issuer-credentials
  retryInterval: 1h
  statusCheckInterval: 6h
  templateName: ${var.certificate_template_name}
  url: ${var.adcs_url}
YAML
}