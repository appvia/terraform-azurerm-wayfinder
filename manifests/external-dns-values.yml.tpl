podAnnotations:
  azure.workload.identity/inject-proxy-sidecar: "true"
podLabels:
  azure.workload.identity/use: "true"
provider: ${dns_provider}
azure:
  resourceGroup: ${resource_group}
  secretName: azure-config-file
  useManagedIdentityExtension: true
  tenantId: ${tenant_id}
  subscriptionId: ${subscription_id}
serviceAccount:
  annotations:
    azure.workload.identity/client-id: ${client_id}
  create: true
  name: external-dns
