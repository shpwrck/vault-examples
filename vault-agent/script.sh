#!/bin/bash

VAULT_ADDR=https://vault-vault-agent.apps.nuc.k8socp.com/

vault login root

vault secrets enable -path=internal kv-v2

vault kv put internal/database/config username="db-readonly-username" password="db-secret-password"

vault auth enable kubernetes

oc exec vault-0 -- /bin/sh -c 'vault write auth/kubernetes/config token_reviewer_jwt="$(cat /run/secrets/kubernetes.io/serviceaccount/token)" kubernetes_host="https://$(printenv KUBERNETES_PORT_443_TCP_ADDR):443" kubernetes_ca_cert="$(cat /run/secrets/kubernetes.io/serviceaccount/ca.crt)"'

vault policy write internal-app - <<EOF
path "internal/data/database/config" {
   capabilities = ["read"]
}
EOF

vault write auth/kubernetes/role/internal-app \
      bound_service_account_names='internal-app' \
      bound_service_account_namespaces='vault-agent' \
      policies=internal-app \
      ttl=24h
