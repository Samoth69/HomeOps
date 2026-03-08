variable "cluster_name" {
  description = "A name to provide for the Talos cluster"
  type        = string
}

variable "cluster_endpoint" {
  description = "The endpoint for the Talos cluster"
  type        = string
}

variable "nodes" {
  description = "Node config"
  type = map(object({
    hostname     = string
    machine_type = string
    install_disk = string
    links        = list(string)
    ips          = list(string)
    routes = list(object({
      destination = string
      gateway    = string
    }))
  }))
  validation {
    // @formatter:off
    condition     = length([for n in var.nodes : n if contains(["controlplane", "worker"], n.machine_type)]) == length(var.nodes)
    error_message = "Node machine_type must be either 'controlplane' or 'worker'."
    // @formatter:on
  }
}
