module "talos" {
  source = "./talos"

  providers = {
    talos=talos
  }

  cluster_name = var.cluster_name
  cluster_endpoint = var.cluster_endpoint
  nodes = var.talos_node
}