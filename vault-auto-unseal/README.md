# Vault Transit Unseal

[Tutorial](https://developer.hashicorp.com/vault/tutorials/auto-unseal/autounseal-transit#setup-the-transit-secrets-engine)

## Notes

* The helm install is very particular.
* My sidecar container solution is far from efficient.

## Sample Command

```
helm upgrade --install --create-namespace -n vault-server-unseal vault-server-unseal hashicorp/vault -f values.yaml
```
