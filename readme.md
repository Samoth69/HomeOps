# HomeOps

Welcome to my home-ops monorepo featuring Kubernetes, FluxCD, Talos and Renovate among others.

If you want to get started in GitOps with Kubernetes, have a look at the excellent [cluster-template](https://github.com/onedr0p/cluster-template)

## Clusters

### k4

Main cluster

## Docker

### PiHoleGamma

Main DNS Server, also running tailscale and other stuff

### PiHoleDelta

Backup DNS Server, automatically mirrored from PiHoleGamma with nebula-sync.

## usefull commands

```bash
# test config
flux-local test --path kubernetes/flux/cluster --enable-helm --all-namespaces -v
# force update flux
flux reconcile source git flux-system
# get flux objects status
flux get all -A --status-selector ready=false
# hubble
cilium hubble port-forward&
hubble observe --verdict DROPPED -f
```
