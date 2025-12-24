# HomeOps

Welcome to my home-ops monorepo featuring Kubernetes, FluxCD, Talos and Renovate among others.

If you want to build something similar, have a look at the excellent [cluster-template](https://github.com/onedr0p/cluster-template)

## Clusters

### Lynka

PiHole + HomeAssistant

#### Nodes

##### KubeLynka

Schematic ID : 4717f83f4e192788abb14eac1d990eebe3e866ff866fbbbf90724c45a4b7af88

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
    bootloader: sd-boot
```