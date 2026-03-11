variable "nodes" {
  description = "Node config"
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
  validation {
    // @formatter:off
    condition     = length([for n in var.nodes : n if contains(["controlplane", "worker"], n.machine_type)]) == length(var.nodes)
    error_message = "Node machine_type must be either 'controlplane' or 'worker'."
    // @formatter:on
  }
}

variable "cluster" {
  type = object({
    name           = string
    endpoint       = string
    pod_subnet     = string
    service_subnet = string
  })
}
