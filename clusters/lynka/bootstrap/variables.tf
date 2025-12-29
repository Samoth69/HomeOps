variable "helm_prometheus_operator_crd_path" {
  type    = string
  default = "../kubernetes/apps/monitoring/prometheus-operator-crds/app"
}

variable "helm_cilium_path" {
  type    = string
  default = "../kubernetes/apps/kube-system/cilium/app"
}

variable "helm_coredns_path" {
  type    = string
  default = "../kubernetes/apps/kube-system/coredns/app"
}

variable "helm_flux_operator_path" {
  type    = string
  default = "../kubernetes/apps/flux-system/flux-operator/app"
}

variable "helm_flux_instance_path" {
  type    = string
  default = "../kubernetes/apps/flux-system/flux-instance/app"
}
