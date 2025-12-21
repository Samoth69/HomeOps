# HomeOps

Welcome to my home-ops monorepo featuring Kubernetes, FluxCD, Talos and Renovate among others.

If you want to build something similar, have a look at the excellent [cluster-template](https://github.com/onedr0p/cluster-template)

## Clusters

### Lynka

PiHole + HomeAssistant

#### Nodes

##### KubeLynka

Schematic ID : c7b863b2ab08aa801177461d21c70d628fc70aae026ea690df38926f9f40c59c

```
customization:
    extraKernelArgs:
        - sysctl.net.ipv6.conf.default.autoconf=0
        - sysctl.net.ipv6.conf.default.accept_ra=0
        - sysctl.net.ipv6.conf.all.autoconf=0
        - sysctl.net.ipv6.conf.all.accept_ra=0
    systemExtensions:
        officialExtensions:
            - siderolabs/qemu-guest-agent
            - siderolabs/util-linux-tools
```