locals {
  helmrelease       = yamldecode(file("${var.app_path}/helmrelease.yaml"))
  ocirepository     = yamldecode(file("${var.app_path}/ocirepository.yaml"))
  ocirepository_url = regex("(.+)\\/(.+)$", local.ocirepository["spec"]["url"])
}

resource "helm_release" "release" {
  name             = local.helmrelease["metadata"]["name"]
  namespace        = var.namespace
  repository       = local.ocirepository_url[0]
  chart            = local.ocirepository_url[1]
  version          = local.ocirepository["spec"]["ref"]["tag"]
  values           = [yamlencode(lookup(local.helmrelease["spec"], "values", null))]
  create_namespace = var.create_namespace
  upgrade_install  = true
}
