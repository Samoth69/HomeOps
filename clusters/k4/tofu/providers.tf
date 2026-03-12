terraform {
  required_providers {
    talos = {
      source  = "siderolabs/talos"
      version = "0.10.1"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "3.0.1"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "3.1.1"
    }
  }
}

provider "kubernetes" {
  # Configuration options
  config_path = "./output/kube-config.yaml"
}

provider "helm" {
  kubernetes = {
    config_path = "./output/kube-config.yaml"
  }
}