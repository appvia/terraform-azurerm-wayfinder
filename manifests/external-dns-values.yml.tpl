fullnameOverride: external-dns
serviceAccount:
  annotations:
    azure.workload.identity/client-id: ${client_id}
podLabels:
  azure.workload.identity/use: "true"
provider: azure
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