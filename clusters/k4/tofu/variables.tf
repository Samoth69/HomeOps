variable "cluster_name" {
  description = "A name to provide for the Talos cluster"
  type        = string
}

variable "cluster_endpoint" {
  description = "The endpoint for the Talos cluster"
  type        = string
}

variable "talos_node" {
  description = "List of talos node"
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
}
