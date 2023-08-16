apiVersion: "aadpodidentity.k8s.io/v1"
kind: AzureIdentityBinding
metadata:
  name: ${azure_identity}
  namespace: wayfinder
spec:
  azureIdentity: ${azure_identity}
  selector: wayfinder-identity