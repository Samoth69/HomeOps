module "talos" {
  source = "./talos"

  providers = {
    talos = talos
  }

  cluster = var.kubernetes_cluster
  nodes   = var.talos_nodes
}
