terraform {
  required_version = ">= 1.0"
  required_providers {
    massdriver = {
      source  = "massdriver-cloud/massdriver"
      version = "~> 1.0"
    }
    scaleway = {
      source  = "scaleway/scaleway"
      version = "~> 2.16"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.0"
    }
    null = {
      source = "hashicorp/null"
    }
  }
}

locals {
  cluster_name           = var.md_metadata.name_prefix
  cluster_ca_certificate = base64decode(data.scaleway_k8s_cluster.main.kubeconfig[0].cluster_ca_certificate)
  cluster_token          = data.scaleway_k8s_cluster.main.kubeconfig[0].token
  cluster_host           = data.scaleway_k8s_cluster.main.kubeconfig[0].host
}

provider "scaleway" {
  access_key = var.scw_authentication.data.access_key
  secret_key = var.scw_authentication.data.secret_key
  project_id = var.scw_authentication.data.project_id
}

provider "kubernetes" {
  host                   = local.cluster_host
  token                  = local.cluster_token
  cluster_ca_certificate = local.cluster_ca_certificate
}

provider "helm" {
  kubernetes {
    host                   = local.cluster_host
    token                  = local.cluster_token
    cluster_ca_certificate = local.cluster_ca_certificate
  }
}
