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

Schematic ID : 1451b597beb63e3da7d2d9db18e702501f53b71ebd46ac65c299142b3adebe7a

```yaml
customization:
    extraKernelArgs:
        - sysctl.net.ipv6.conf.default.autoconf=0
        - sysctl.net.ipv6.conf.default.accept_ra=0
        - sysctl.net.ipv6.conf.all.autoconf=0
        - sysctl.net.ipv6.conf.all.accept_ra=0
        - tsc=nowatchdog
        - cpufreq.default_governor=performance
    systemExtensions:
        officialExtensions:
            - siderolabs/amd-ucode
            - siderolabs/amdgpu
            - siderolabs/realtek-firmware
            - siderolabs/util-linux-tools
    bootloader: sd-boot
```

## Enigma

Schematic ID : eba40428eb923227b9b8bdafd86a217ee34e1e1b42307432ee261fb0767547cb

```yaml
customization:
    extraKernelArgs:
        - sysctl.net.ipv6.conf.default.autoconf=0
        - sysctl.net.ipv6.conf.default.accept_ra=0
        - sysctl.net.ipv6.conf.all.autoconf=0
        - sysctl.net.ipv6.conf.all.accept_ra=0
        - tsc=nowatchdog
        - cpufreq.default_governor=performance
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
