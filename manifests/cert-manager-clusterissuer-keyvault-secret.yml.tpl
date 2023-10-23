apiVersion: secrets-store.csi.x-k8s.io/v1
kind: SecretProviderClass
metadata:
  name: keyvault-issuer
spec:
  provider: azure
  secretObjects:
    - secretName: keyvault-issuer
      type: kubernetes.io/tls
      data: 
        - objectName: ${keyvault_cert_name}
          key: tls.key
        - objectName: ${keyvault_cert_name}
          key: tls.crt
  parameters:
    usePodIdentity: "false"
    useVMManagedIdentity: "true"
    userAssignedIdentityID: <client id>
    keyvaultName: ${keyvault_name}
    objects: |
      array:
        - |
          objectName: ${keyvault_cert_name}
          objectType: secret
    tenantId: ${tenant_id}