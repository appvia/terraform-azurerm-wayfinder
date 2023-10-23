apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: keyvault-issuer
spec:
  ca:
    secretName: private-ca-keyvault
