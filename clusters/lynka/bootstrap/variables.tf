variable "helm_prometheus_operator_crd_path" {
  type    = string
  default = "../kubernetes/apps/monitoring/prometheus-operator-crds/app"
}

variable "helm_cilium_path" {
  type    = string
  default = "../kubernetes/apps/kube-system/cilium/app"
}
