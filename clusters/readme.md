# Clusters

To output kubeconfig & talosconfig, go inside a cluster folder and type `mise tf:output`, make sure to be inside a cluster folder

## Bootstrap

```bash
cd talos
tofu apply

cd ..
mise tf:output

cd bootstrap
tofu apply
```

## Lynka

pod_cidr: 
- 10.1.0.0/16
- fd00:1::/64

service_cidr:
- 10.2.0.0/16
- fd00:2::/64