# Vault Agent (Local)

## Sample Command

```
helm upgrade --install --create-namespace -n vault-agent vault hashicorp/vault -f values.yaml
```

## Useful Links

[Annotations](https://developer.hashicorp.com/vault/docs/platform/k8s/injector/annotations)
[Tutorial](https://developer.hashicorp.com/vault/tutorials/kubernetes/kubernetes-sidecar)

## Notes

* Make sure you apply annotations at the right location.
* Secrets can be `sa` bound or `ns` bound.
