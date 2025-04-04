#!/bin/bash

oc project vault-csi
oc adm policy add-scc-to-user privileged -z vault-csi-provider

VAULT_ADDR=https://vault-vault-csi.apps.nuc.k8socp.com/

vault login root
vault kv put secret/db-pass password="db-secret-password"

vault auth enable kubernetes

oc exec vault-0 -- /bin/sh -c 'vault write auth/kubernetes/config token_reviewer_jwt="$(cat /run/secrets/kubernetes.io/serviceaccount/token)" kubernetes_host="https://$(printenv KUBERNETES_PORT_443_TCP_ADDR):443" kubernetes_ca_cert="$(cat /run/secrets/kubernetes.io/serviceaccount/ca.crt)"'

vault policy write internal-app - <<EOF
path "secret/data/db-pass" {
  capabilities = ["read"]
}
EOF

vault write auth/kubernetes/role/database \
    bound_service_account_names="*" \
    bound_service_account_namespaces="*" \
    policies=internal-app \
    ttl=20m
