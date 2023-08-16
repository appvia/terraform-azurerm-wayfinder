podAnnotations:
  azure.workload.identity/inject-proxy-sidecar: "true"
podLabels:
  azure.workload.identity/use: "true"
provider: azure
azure:
  resourceGroup: ${resource_group}
  secretName: azure-config-file
  useManagedIdentityExtension: true
serviceAccount:
  annotations:
    azure.workload.identity/client-id: ${client_id}
  create: true
  name: external-dns
