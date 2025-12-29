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

locals {
  prometheus_hr      = yamldecode(file("${var.helm_prometheus_operator_crd_path}/helmrelease.yaml"))
  prometheus_oci     = yamldecode(file("${var.helm_prometheus_operator_crd_path}/ocirepository.yaml"))
  prometheus_oci_url = regex("(.+)\\/(.+)$", local.prometheus_oci["spec"]["url"])
}

resource "helm_release" "helm-prometheus-operator-crds" {
  name             = local.prometheus_hr["metadata"]["name"]
  namespace        = "monitoring"
  repository       = local.prometheus_oci_url[0]
  chart            = local.prometheus_oci_url[1]
  version          = local.prometheus_oci["spec"]["ref"]["tag"]
  create_namespace = true
}

locals {
  cilium_hr      = yamldecode(file("${var.helm_cilium_path}/helmrelease.yaml"))
  cilium_oci     = yamldecode(file("${var.helm_cilium_path}/ocirepository.yaml"))
  cilium_oci_url = regex("(.+)\\/(.+)$", local.cilium_oci["spec"]["url"])
}

resource "helm_release" "helm-cilium" {
  depends_on = [helm_release.helm-prometheus-operator-crds]
  name       = local.cilium_hr["metadata"]["name"]
  namespace  = "kube-system"
  repository = local.cilium_oci_url[0]
  chart      = local.cilium_oci_url[1]
  version    = local.cilium_oci["spec"]["ref"]["tag"]
  values     = [yamlencode(local.cilium_hr["spec"]["values"])]
}
