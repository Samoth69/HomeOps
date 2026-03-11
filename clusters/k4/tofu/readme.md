# Talos

Heavily inspired by https://github.com/vehagn/homelab/tree/main/tofu/kubernetes

## Schematics

### Tatsumi

- c35c07b8adb1b04b999c6fc285924a378ad0be5915b5523a2e2ef2b99e500815

```yaml
customization:
    extraKernelArgs:
        - net.ipv6.conf.default.autoconf=0
        - net.ipv6.conf.default.accept_ra=0
        - net.ipv6.conf.all.autoconf=0
        - net.ipv6.conf.all.accept_ra=0
        - cpufreq.default_governor=performance
    systemExtensions:
        officialExtensions:
            - siderolabs/btrfs
            - siderolabs/kata-containers
            - siderolabs/qemu-guest-agent
            - siderolabs/util-linux-tools
    bootloader: sd-boot
```

### Lynka

- b84e1e3216cac01a1d1333e9a6c60b6ff5f3520dc1b4284d4532af86eadda828

```yaml
customization:
    extraKernelArgs:
        - net.ipv6.conf.default.autoconf=0
        - net.ipv6.conf.default.accept_ra=0
        - net.ipv6.conf.all.autoconf=0
        - net.ipv6.conf.all.accept_ra=0
        - cpufreq.default_governor=performance
    systemExtensions:
        officialExtensions:
            - siderolabs/amd-ucode
            - siderolabs/amdgpu
            - siderolabs/kata-containers
            - siderolabs/realtek-firmware
            - siderolabs/util-linux-tools
    bootloader: sd-boot
```

### Enigma

- dd92fd7b6a91fc082cf020e90b1551053de8d3809a6233bd427eb3b7b0f0c8b6

```yaml
customization:
    extraKernelArgs:
        - net.ipv6.conf.default.autoconf=0
        - net.ipv6.conf.default.accept_ra=0
        - net.ipv6.conf.all.autoconf=0
        - net.ipv6.conf.all.accept_ra=0
        - cpufreq.default_governor=performance
    systemExtensions:
        officialExtensions:
            - siderolabs/i915
            - siderolabs/intel-ice-firmware
            - siderolabs/intel-ucode
            - siderolabs/kata-containers
            - siderolabs/mei
            - siderolabs/realtek-firmware
            - siderolabs/util-linux-tools
            - siderolabs/xe
    bootloader: sd-boot
```