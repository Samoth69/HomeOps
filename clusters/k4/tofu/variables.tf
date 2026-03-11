variable "talos_nodes" {
  description = "List of talos node"
  type = map(object({
    hostname     = string
    machine_type = string
    image        = string
    install_disk = string
    links        = list(string)
    ips          = list(string)
    routes = list(object({
      gateway = string
    }))
    dns            = list(string)
    kernel_modules = optional(list(string))
  }))
}

variable "kubernetes_cluster" {
  type = object({
    name           = string
    endpoint       = string
    pod_subnet     = string
    service_subnet = string
  })
}
