apiVersion: cloudaccess.appvia.io/v2beta2
kind: CloudAccessConfig
metadata:
  name: azure-cloudinfo
  namespace: ws-admin
spec:
  cloud: azure
  azure:
    subscription: ${subscription_id}
    tenantID: ${tenant_id}
  description: Platform cloud metadata access, created by Wayfinder install
  type: CostsEstimates
  cloudIdentityRef:
    cloud: azure
    name: ${identity}
  permissions:
  - permission: CloudInfo
