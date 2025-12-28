resource "talos_machine_secrets" "this" {}

data "talos_machine_configuration" "controlplane" {
  cluster_name     = var.cluster_name
  cluster_endpoint = var.cluster_endpoint
  machine_type     = "controlplane"
  machine_secrets  = talos_machine_secrets.this.machine_secrets
}

data "talos_client_configuration" "this" {
  cluster_name         = var.cluster_name
  client_configuration = talos_machine_secrets.this.client_configuration
  endpoints            = [var.node_ip]
}

resource "talos_machine_configuration_apply" "controlplane" {
  client_configuration        = talos_machine_secrets.this.client_configuration
  machine_configuration_input = data.talos_machine_configuration.controlplane.machine_configuration
  node                        = var.node_ip
  on_destroy = {
    graceful = false
    reset    = true
  }
  config_patches = [
    yamlencode({
      apiVersion = "v1alpha1"
      kind       = "LinkConfig"
      name       = "eth0"
      addresses  = [for k, v in var.node_network_addresses : { address = v }]
      routes = [
        {
          gateway = var.node_network_routes_ipv4_gateway
        },
        {
          gateway = var.node_network_routes_ipv6_gateway
        },
      ]
    }),
    yamlencode({
      apiVersion = "v1alpha1"
      kind       = "HostnameConfig"
      auto       = "off"
      hostname   = var.hostname
    }),
    yamlencode({
      apiVersion  = "v1alpha1"
      kind        = "ResolverConfig"
      nameservers = [for k, v in var.node_network_nameservers : { address = v }]
      searchDomains = {
        disableDefault = true
      }
    }),
    yamlencode({
      apiVersion = "v1alpha1"
      kind       = "TimeSyncConfig"
      ntp = {
        servers = ["162.159.200.1", "162.159.200.123"]
      }
    }),
    yamlencode({
      machine = {
        type = "controlplane",
        install = {
          image             = "factory.talos.dev/nocloud-installer-secureboot/4717f83f4e192788abb14eac1d990eebe3e866ff866fbbbf90724c45a4b7af88:v1.12.0"
          disk              = "/dev/sda"
          legacyBIOSSupport = false
          wipe              = true
        },
        kubelet = {
          defaultRuntimeSeccompProfileEnabled = true
          disableManifestsDirectory           = true
          extraConfig = {
            serializeImagePulls = false
          }
          nodeIP = {
            validSubnets = var.node_kubelet_nodeip_validsubnets
          }
        }
        features = {
          hostDNS = {
            enabled              = true
            forwardKubeDNSToHost = false
          }
        }
        udev = {
          rules = [
            # IO scheduler
            # Algorithm to manage disk IO requests and balance it with other CPU loads.
            # HDD
            "ACTION=='add|change', KERNEL=='sd[a-z]', ATTR{queue/rotational}=='1', ATTR{queue/scheduler}='mq-deadline'",
            # SSD
            "ACTION=='add|change', KERNEL=='sd[a-z]', ATTR{queue/rotational}=='0', ATTR{queue/scheduler}='none'",
            # NVMe SSD
            "ACTION=='add|change', KERNEL=='nvme[0-9]n[0-9]', ATTR{queue/rotational}=='0', ATTR{queue/scheduler}='none'"
          ]
        }
        sysctls = {
          # IPv6 requirements
          "net.ipv6.conf.default.autoconf"  = 0
          "net.ipv6.conf.default.accept_ra" = 0
          "net.ipv6.conf.all.autoconf"      = 0
          "net.ipv6.conf.all.accept_ra"     = 0
          # Watchdog
          "fs.inotify.max_user_watches"   = 1048576
          "fs.inotify.max_user_instances" = 8192
        }
      }
      cluster = {
        allowSchedulingOnControlPlanes = true
        apiServer = {
          disablePodSecurityPolicy = true
        }
        controllerManager = {
          extraArgs = {
            bind-address = "0.0.0.0"
          }
        }
        coreDNS = {
          disabled = true
        }
        etcd = {
          extraArgs = {
            listen-metrics-urls = "http://0.0.0.0:2381"
          }
        }
        network = {
          cni = {
            name = "none"
          }
        }
        proxy = {
          disabled = true
        }
        scheduler = {
          extraArgs = {
            bind-address = "0.0.0.0"
          }
        }
      }
    })
  ]
}

resource "talos_machine_bootstrap" "this" {
  depends_on = [talos_machine_configuration_apply.controlplane]

  client_configuration = talos_machine_secrets.this.client_configuration
  node                 = var.node_ip
}

resource "talos_cluster_kubeconfig" "this" {
  depends_on           = [talos_machine_bootstrap.this]
  client_configuration = talos_machine_secrets.this.client_configuration
  node                 = var.node_ip
}
