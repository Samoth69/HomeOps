locals {
  control_planes              = [for k, v in var.nodes : v if v.machine_type == "controlplane"]
  control_plane_ips           = [for k, v in local.control_planes : split("/", v.ips[0])[0]]
  workers                     = [for k, v in var.nodes : v if v.machine_type == "worker"]
  worker_ips                  = [for k, v in local.workers : split("/", v.ips[0])[0]]
  first_control_plane_node_ip = local.control_plane_ips[0]
  endpoint_url                = "https://${var.cluster.endpoint_ip}:${var.cluster.endpoint_port}"
}

resource "talos_machine_secrets" "this" {}

data "talos_machine_configuration" "this" {
  for_each         = var.nodes
  cluster_name     = var.cluster.name
  cluster_endpoint = local.endpoint_url
  machine_type     = each.value.machine_type
  machine_secrets  = talos_machine_secrets.this.machine_secrets
}

data "talos_client_configuration" "this" {
  cluster_name         = var.cluster.name
  client_configuration = talos_machine_secrets.this.client_configuration
  endpoints            = local.control_plane_ips
}

resource "talos_machine_configuration_apply" "this" {
  for_each                    = var.nodes
  client_configuration        = talos_machine_secrets.this.client_configuration
  machine_configuration_input = data.talos_machine_configuration.this[each.key].machine_configuration
  node                        = each.key
  endpoint                    = split("/", each.value.ips[0])[0]
  on_destroy = {
    graceful = false
    reboot   = true
    reset    = true
  }
  config_patches = [
    templatefile("${path.module}/templates/machine.yaml.tmpl", {
      machine_type   = each.value.machine_type
      image          = each.value.image
      kernel_modules = each.value.kernel_modules
    }),
    templatefile("${path.module}/templates/cluster.yaml.tmpl", {
      is_controlplane  = each.value.machine_type == "controlplane"
      cluster_name     = var.cluster.name
      cluster_endpoint = local.endpoint_url
      pod_subnets      = var.cluster.pod_subnets
      service_subnets  = var.cluster.service_subnets
    }),
    templatefile("${path.module}/templates/network.yaml.tmpl", {
      hostname     = each.value.hostname
      ifnames      = each.value.links
      ip_addresses = each.value.ips
      routes       = each.value.routes
      dns          = each.value.dns
      vip          = var.cluster.endpoint_ip
    }),
    file("${path.module}/files/watchdog.yaml"),
    file("${path.module}/files/volumes.yaml")
  ]
}

resource "talos_machine_bootstrap" "this" {
  depends_on = [talos_machine_configuration_apply.this]

  client_configuration = talos_machine_secrets.this.client_configuration
  node                 = local.first_control_plane_node_ip
}

resource "talos_cluster_kubeconfig" "this" {
  depends_on           = [talos_machine_bootstrap.this]
  client_configuration = talos_machine_secrets.this.client_configuration
  node                 = local.first_control_plane_node_ip
}

data "talos_cluster_health" "this" {
  depends_on = [
    talos_machine_configuration_apply.this,
    talos_machine_bootstrap.this
  ]
  # Cluster will not be ready at this time because Cilium isn't installed yet
  skip_kubernetes_checks = true
  client_configuration   = talos_machine_secrets.this.client_configuration
  control_plane_nodes    = local.control_plane_ips
  worker_nodes           = local.worker_ips
  endpoints              = local.control_plane_ips
  timeouts = {
    read = "10m"
  }
}
