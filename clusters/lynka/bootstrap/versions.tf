terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "3.1.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "3.1.1"
    }
  }
}

provider "kubernetes" {
  # Configuration options
  config_path = "../output/kube-config.yaml"
}

provider "helm" {
  kubernetes = {
    config_path = "../output/kube-config.yaml"
  }
}