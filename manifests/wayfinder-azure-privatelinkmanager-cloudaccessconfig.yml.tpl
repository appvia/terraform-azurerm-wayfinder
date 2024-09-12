apiVersion: cloudaccess.appvia.io/v2beta2
kind: CloudAccessConfig
metadata:
  name: azure-privatelinks
  namespace: ws-admin
spec:
  cloud: azure
  azure:
    subscription: ${subscription_id}
    tenantID: ${tenant_id}
  description: Platform Private Link Management, created by Wayfinder install
  type: NetworkPrivateLinks
  cloudIdentityRef:
    cloud: azure
    name: ${identity}
  permissions:
  - permission: PrivateLinkManager
