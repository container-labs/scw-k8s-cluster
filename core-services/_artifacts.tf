locals {
  data_infrastructure = {
    id = data.scaleway_k8s_cluster.main.id
  }

  data_authentication = {
    cluster = {
      server                     = local.cluster_host
      certificate-authority-data = data.scaleway_k8s_cluster.main.kubeconfig[0].cluster_ca_certificate
    }
    user = {
      token = data.scaleway_k8s_cluster.main.kubeconfig[0].token
    }
  }

  specs_kubernetes = {
    cloud        = "gcp"
    distribution = "gke"
    version      = data.scaleway_k8s_cluster.main.version
    # platform_version = split("-", data.google_container_cluster.cluster.master_version)[1]
  }

  kubernetes_cluster_artifact = {
    data = {
      infrastructure = local.data_infrastructure
      authentication = local.data_authentication
    }
    specs = {
      kubernetes = local.specs_kubernetes
    }
  }
}

resource "massdriver_artifact" "kubernetes_cluster" {
  field                = "kubernetes_cluster"
  provider_resource_id = data.scaleway_k8s_cluster.main.id
  name                 = "SCW Cluster Credentials ${var.md_metadata.name_prefix}"
  artifact             = jsonencode(local.kubernetes_cluster_artifact)
}
