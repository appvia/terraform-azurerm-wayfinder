api:
  azure:
    wayfinderClusterId: ${wayfinder_cluster_id}
    wayfinderMsiClientId: ${wayfinder_client_id}
  enabled: true
  endpoint:
    url: "https://${api_hostname}"
  ingress:
    enabled: true
    hostname: "${api_hostname}"
    tlsEnabled: true
    tlsSecret: "wayfinder-ingress-api-tls"
    annotations:
      cert-manager.io/cluster-issuer: letsencrypt-prod
      nginx.ingress.kubernetes.io/backend-protocol: "HTTPS"
      nginx.ingress.kubernetes.io/proxy-buffer-size: '16k'
    namespace: "ingress-nginx"
    className: "nginx"
  wayfinderInstanceIdentifier: "${wayfinder_instance_identifier}"
  wfManagedWfCluster: true
disableLocalLogin: ${disable_local_login}
enableLocalAdminUser: ${enable_localadmin_user}
mysql:
  pvc:
    storageClass: "${storage_class}"
ui:
  cloudOrder: "['azure','aws','gcp']"
  enabled: true
  endpoint:
    url: "https://${ui_hostname}"
  ingress:
    enabled: true
    hostname: "${ui_hostname}"
    tlsEnabled: true
    tlsSecret: "wayfinder-ingress-ui-tls"
    annotations:
      cert-manager.io/cluster-issuer: letsencrypt-prod
      nginx.ingress.kubernetes.io/backend-protocol: "HTTPS"
    namespace: "ingress-nginx"
    className: "nginx"
