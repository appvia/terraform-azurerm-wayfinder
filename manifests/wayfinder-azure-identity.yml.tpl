apiVersion: "aadpodidentity.k8s.io/v1"
kind: AzureIdentity
metadata:
  name: ${name}
  namespace: wayfinder
spec:
  type: 0
  resourceID: ${resource_id}
  clientID: ${client_id}
