locals {
  enable_cert_manager = length(var.core_services.dns_zones) > 0
  enable_external_dns = length(var.core_services.dns_zones) > 0

  core_services_namespace = "md-core-services"

  managed_zones = [for zone in var.core_services.dns_zones :
    length(split("/", zone)) > 1 ? split("/", zone)[3] : zone
  ]
}

data "scaleway_k8s_cluster" "main" {
  name = local.cluster_name
}

module "ingress_nginx" {
  source             = "github.com/massdriver-cloud/terraform-modules//k8s-ingress-nginx?ref=c336d59"
  count              = var.core_services.enable_ingress ? 1 : 0
  kubernetes_cluster = local.kubernetes_cluster_artifact
  md_metadata        = var.md_metadata
  release            = "ingress-nginx"
  namespace          = local.core_services_namespace
}

module "external_dns" {
  # source                  = "github.com/massdriver-cloud/terraform-modules//k8s-external-dns-scw"
  source             = "../../../terraform-modules/k8s-external-dns-scw"
  count              = local.enable_external_dns ? 1 : 0
  kubernetes_cluster = local.kubernetes_cluster_artifact
  md_metadata        = var.md_metadata
  release            = "external-dns"
  namespace          = local.core_services_namespace
  dns_zones          = var.core_services.dns_zones
  scw_authentication = {
    access_key = var.scw_authentication.data.access_key
    secret_key = var.scw_authentication.data.secret_key
  }
}

module "cert_manager" {
  # source             = "github.com/massdriver-cloud/terraform-modules//k8s-cert-manager-scw"
  source             = "../../../terraform-modules/k8s-cert-manager-scw"
  count              = local.enable_cert_manager ? 1 : 0
  kubernetes_cluster = local.kubernetes_cluster_artifact
  md_metadata        = var.md_metadata
  release            = "cert-manager"
  namespace          = local.core_services_namespace
}
