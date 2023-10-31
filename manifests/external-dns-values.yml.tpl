fullnameOverride: external-dns
serviceAccount:
  annotations:
    azure.workload.identity/client-id: ${client_id}
podLabels:
  azure.workload.identity/use: "true"
provider: ${dns_provider}
azure:
  resourceGroup: ${resource_group}
  secretName: azure-config-file
  useManagedIdentityExtension: true
  tenantId: ${tenant_id}
  subscriptionId: ${subscription_id}
secretConfiguration:
  enabled: true
  mountPath: "/etc/kubernetes/"
  data:
    azure.json: |
      {
        "subscriptionId": "${subscription_id}",
        "resourceGroup": "${resource_group}",
        "useWorkloadIdentityExtension": true
      }