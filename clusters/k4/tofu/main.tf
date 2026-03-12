module "talos" {
  source = "./talos"

  providers = {
    talos = talos
  }

  cluster = var.kubernetes_cluster
  nodes   = var.talos_nodes
}

module "kubernetes" {
  source = "./kubernetes"

  depends_on = [module.talos]

  providers = {
    kubernetes = kubernetes
    helm       = helm
  }
}
