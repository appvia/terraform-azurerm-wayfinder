installCRDs: true
podLabels:
  azure.workload.identity/use: "true"
serviceAccount:
  labels:
    azure.workload.identity/use: "true"
ingressShim:
  defaultIssuerName: ${clusterissuer}
  defaultIssuerKind: ${issuerkind}
  defaultIssuerGroup: ${issuergroup}
