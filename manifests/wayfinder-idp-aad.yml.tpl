apiVersion: v1
stringData:
  WF_IDP_CLIENT_ID: ${client_id}
  WF_IDP_CLIENT_SCOPES: ${client_scopes}
  WF_IDP_CLIENT_SECRET: ${client_secret}
  WF_IDP_PROVIDER: ${provider}
  WF_IDP_PROVIDER_PARAMS: "{\"tenant\":\"${tenant_id}\"}"
  WF_IDP_SERVER_URL: "https://login.microsoftonline.com/${tenant_id}/v2.0"
  WF_IDP_USER_CLAIMS: ${claims}
kind: Secret
metadata:
  name: ${name}
  namespace: ${namespace}
type: Opaque
