locals {
  age-publickey  = yamldecode(file("../kubernetes/components/sops/cluster-secrets.sops.yaml"))["sops"]["age"][0]["recipient"]
  age-privatekey = regex("${local.age-publickey}\\n([A-Z0-9\\-]+)", file("../../../age.key"))[0]
}

resource "kubernetes_namespace_v1" "flux-system-namespace" {
  metadata {
    name = "flux-system"
  }

  lifecycle {
    ignore_changes = [metadata]
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

resource "kubernetes_manifest" "this" {
  for_each = toset(["egress/labelled-allow-egress-kube-apiserver.yaml", "egress/labelled-allow-egress-internet-github.yaml", "egress/labelled-allow-egress-internet-http.yaml"])
  manifest = yamldecode(file("../../../common/cilium/policies/${each.value}"))
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
  depends_on = [module.helm-coredns, kubernetes_manifest.this]
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
