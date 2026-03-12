locals {
  age-publickey  = yamldecode(file("../kubernetes/components/sops/cluster-secrets.sops.yaml"))["sops"]["age"][0]["recipient"]
  age-privatekey = regex("${local.age-publickey}\\n([A-Z0-9\\-]+)", file("../../../age.key"))[0]
}

resource "kubernetes_namespace_v1" "flux-system-namespace" {
  metadata {
    name = "flux-system"
  }
}

resource "kubernetes_secret_v1" "sops-age-secret" {
  depends_on = [kubernetes_namespace_v1.flux-system-namespace]

  metadata {
    name      = "sops-age"
    namespace = "flux-system"
  }

  data = {
    "age.agekey" = local.age-privatekey
  }
}

module "helm-prometheus-operator-crds" {
  source           = "./helm-release"
  app_path         = "../kubernetes/apps/monitoring/prometheus-operator-crds/app"
  namespace        = "monitoring"
  create_namespace = true
}

module "helm-cilium" {
  depends_on = [module.helm-prometheus-operator-crds]
  source     = "./helm-release"
  app_path   = "../kubernetes/apps/kube-system/cilium/app"
  namespace  = "kube-system"
}

module "helm-coredns" {
  depends_on = [module.helm-cilium]
  source     = "./helm-release"
  app_path   = "../kubernetes/apps/kube-system/coredns/app"
  namespace  = "kube-system"
}

module "helm-flux-operator" {
  depends_on = [module.helm-coredns]
  source     = "./helm-release"
  app_path   = "../kubernetes/apps/flux-system/flux-operator/app"
  namespace  = "flux-system"
}

module "helm-flux-instance" {
  depends_on = [module.helm-flux-operator, kubernetes_secret_v1.sops-age-secret]
  source     = "./helm-release"
  app_path   = "../kubernetes/apps/flux-system/flux-instance/app"
  namespace  = "flux-system"
}
