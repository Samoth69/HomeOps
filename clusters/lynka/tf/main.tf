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
  config_patches = [
    yamlencode({
      machine = {
        type = "controlplane",
        install = {
          image             = "factory.talos.dev/nocloud-installer-secureboot/c7b863b2ab08aa801177461d21c70d628fc70aae026ea690df38926f9f40c59c:v1.11.6"
          disk              = "/dev/sda"
          legacyBIOSSupport = false
          wipe              = true
        },
        network = {
          hostname            = var.hostname
          nameservers         = var.node_network_nameservers
          disableSearchDomain = true
          interfaces = [{
            interface = "eth0"
            addresses = var.node_network_addresses
            dhcp      = false
            dhcpOptions = {
              ipv4 = false
              ipv6 = false
            }
            routes = [
              {
                network = "0.0.0.0/0",
                gateway = var.node_network_routes_ipv4_gateway
              },
              {
                network = "::/0",
                gateway = var.node_network_routes_ipv6_gateway
              },
            ]
          }],
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
        sysctls = {
          "net.ipv6.conf.default.autoconf"  = 0
          "net.ipv6.conf.default.accept_ra" = 0
          "net.ipv6.conf.all.autoconf"      = 0
          "net.ipv6.conf.all.accept_ra"     = 0
        }
      }
      cluster = {
        allowSchedulingOnControlPlanes = true
      }
    }),
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
