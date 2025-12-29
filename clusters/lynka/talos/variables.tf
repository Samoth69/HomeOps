variable "cluster_name" {
  description = "A name to provide for the Talos cluster"
  type        = string
}

variable "cluster_endpoint" {
  description = "A endpoint to provide for the Talos cluster"
  type        = string
}

variable "hostname" {
  description = "A name to provide for the Talos node"
  type        = string
}

variable "node_ip" {
  description = "ip address of the node"
  type        = string
}

variable "node_network_nameservers" {
  description = "List of nameservers for this node"
  type        = list(string)
}

variable "node_network_addresses" {
  description = "List of ip addresses for this node"
  type        = list(string)
}

variable "node_kubelet_nodeip_validsubnets" {
  description = "List of ip valid for kubelet"
  type        = list(string)
}

variable "node_network_routes_ipv4_gateway" {
  description = "node ipv4 gateway"
  type        = string
}

variable "node_network_routes_ipv6_gateway" {
  description = "node ipv6 gateway"
  type        = string
}

variable "pod_subnets" {
  type = list(string)
}

variable "service_subnets" {
  type = list(string)
}
