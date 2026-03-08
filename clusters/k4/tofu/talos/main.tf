locals {
  control_planes              = [for k, v in var.nodes : v if v.machine_type == "controlplane"]
  control_plane_ips           = [for k, v in local.control_planes : v.ips[0]]
  first_control_plane_node_ip = local.control_plane_ips[0]
}

resource "talos_machine_secrets" "this" {}

data "talos_machine_configuration" "controlplane" {
  cluster_name     = var.cluster_name
  cluster_endpoint = var.cluster_endpoint
  machine_type     = "controlplane"
  machine_secrets  = talos_machine_secrets.this.machine_secrets
}

data "talos_machine_configuration" "worker" {
  cluster_name     = var.cluster_name
  cluster_endpoint = var.cluster_endpoint
  machine_type     = "worker"
  machine_secrets  = talos_machine_secrets.this.machine_secrets
}

data "talos_client_configuration" "this" {
  cluster_name         = var.cluster_name
  client_configuration = talos_machine_secrets.this.client_configuration
  endpoints            = local.control_plane_ips
}

resource "talos_machine_configuration_apply" "controlplane" {
  client_configuration        = talos_machine_secrets.this.client_configuration
  machine_configuration_input = data.talos_machine_configuration.controlplane.machine_configuration
  for_each                    = var.nodes
  node                        = each.key
  config_patches = [
    templatefile("${path.module}/templates/machine.yaml.tmpl", {
      hostname     = each.value.hostname
      install_disk = each.value.install_disk
    }),
    templatefile("${path.module}/templates/cluster.yaml.tmpl", {
      is_controlplane = each.value.machine_type == "controlplane"
    }),
    templatefile("${path.module}/templates/network.yaml.tmpl", {
      ifnames      = each.value.links
      ip_addresses = each.value.ips
      routes       = each.value.routes
    })
  ]
}

resource "talos_machine_bootstrap" "this" {
  depends_on = [talos_machine_configuration_apply.controlplane]

  client_configuration = talos_machine_secrets.this.client_configuration
  node                 = local.first_control_plane_node_ip
}

resource "talos_cluster_kubeconfig" "this" {
  depends_on           = [talos_machine_bootstrap.this]
  client_configuration = talos_machine_secrets.this.client_configuration
  node                 = local.first_control_plane_node_ip
}
