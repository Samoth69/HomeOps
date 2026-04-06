# Nodes

## Tatsumi

Schematic ID : 243e9017c341814ac449c81d89d578f62d874e9309960fbaaef3da185a86e0f8

```yaml
customization:
    extraKernelArgs:
        - sysctl.net.ipv6.conf.default.autoconf=0
        - sysctl.net.ipv6.conf.default.accept_ra=0
        - sysctl.net.ipv6.conf.all.autoconf=0
        - sysctl.net.ipv6.conf.all.accept_ra=0
    systemExtensions:
        officialExtensions:
            - siderolabs/btrfs
            - siderolabs/kata-containers
            - siderolabs/qemu-guest-agent
            - siderolabs/util-linux-tools
    bootloader: sd-boot
```

## Lynka

Schematic ID : 607ceea426d4d52b09ad1f681a99cea86a78747086cf91e03564e742ee711f09

```yaml
customization:
    extraKernelArgs:
        - sysctl.net.ipv6.conf.default.autoconf=0
        - sysctl.net.ipv6.conf.default.accept_ra=0
        - sysctl.net.ipv6.conf.all.autoconf=0
        - sysctl.net.ipv6.conf.all.accept_ra=0
        - tsc=nowatchdog
    systemExtensions:
        officialExtensions:
            - siderolabs/amd-ucode
            - siderolabs/amdgpu
            - siderolabs/realtek-firmware
            - siderolabs/util-linux-tools
    bootloader: sd-boot
```

## Enigma

Schematic ID : a6fbe9f8c137852433e00b22a3a54dbfb2ffc27bea528715d6d057c431bf4de9

```yaml
customization:
    extraKernelArgs:
        - sysctl.net.ipv6.conf.default.autoconf=0
        - sysctl.net.ipv6.conf.default.accept_ra=0
        - sysctl.net.ipv6.conf.all.autoconf=0
        - sysctl.net.ipv6.conf.all.accept_ra=0
        - tsc=nowatchdog
    systemExtensions:
        officialExtensions:
            - siderolabs/i915
            - siderolabs/intel-ice-firmware
            - siderolabs/intel-ucode
            - siderolabs/mei
            - siderolabs/realtek-firmware
            - siderolabs/util-linux-tools
            - siderolabs/xe
    bootloader: sd-boot
```
