# Nodes

## Tatsumi

Schematic ID : f30289c5c15d2bf37bb48b2d4aff89e387e20470432257bd94ef52c6c3db1a7f

```yaml
customization:
    extraKernelArgs:
        - sysctl.net.ipv6.conf.default.autoconf=0
        - sysctl.net.ipv6.conf.default.accept_ra=0
        - sysctl.net.ipv6.conf.all.autoconf=0
        - sysctl.net.ipv6.conf.all.accept_ra=0
        - initcall_blacklist=algif_aead_init # https://copy.fail/
    systemExtensions:
        officialExtensions:
            - siderolabs/btrfs
            - siderolabs/kata-containers
            - siderolabs/qemu-guest-agent
            - siderolabs/util-linux-tools
    bootloader: sd-boot
```

## Lynka

Schematic ID : 7f404084e20b4c65cd633f5cdcfebab1c080214db9fc99229a57126b7a146189

```yaml
customization:
    extraKernelArgs:
        - sysctl.net.ipv6.conf.default.autoconf=0
        - sysctl.net.ipv6.conf.default.accept_ra=0
        - sysctl.net.ipv6.conf.all.autoconf=0
        - sysctl.net.ipv6.conf.all.accept_ra=0
        - cpufreq.default_governor=performance
        - initcall_blacklist=algif_aead_init # https://copy.fail/
    systemExtensions:
        officialExtensions:
            - siderolabs/amd-ucode
            - siderolabs/amdgpu
            - siderolabs/kata-containers
            - siderolabs/realtek-firmware
            - siderolabs/util-linux-tools
    bootloader: sd-boot
```

## Enigma

Schematic ID : 473463d952f6d2c1ee0f1dbc5a413df01ad65658f1d9c4794f8fa749137b4fb6

```yaml
customization:
    extraKernelArgs:
        - sysctl.net.ipv6.conf.default.autoconf=0
        - sysctl.net.ipv6.conf.default.accept_ra=0
        - sysctl.net.ipv6.conf.all.autoconf=0
        - sysctl.net.ipv6.conf.all.accept_ra=0
        - cpufreq.default_governor=performance
        - initcall_blacklist=algif_aead_init # https://copy.fail/
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
