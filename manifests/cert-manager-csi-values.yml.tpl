volumes:
  - name: secrets-store-inline
    csi:
      driver: secrets-store.csi.k8s.io
      readOnly: true
      volumeAttributes:
        secretProviderClass: "keyvault-issuer"
volumeMounts:
  - name: secrets-store-inline
    mountPath: "/mnt/signing-cert"
    readOnly: true