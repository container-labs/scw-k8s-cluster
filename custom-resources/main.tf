locals {
  enable_cert_manager     = length(var.core_services.dns_zones) > 0
  core_services_namespace = "md-core-services"

  managed_zones = [for zone in var.core_services.dns_zones :
    length(split("/", zone)) > 1 ? split("/", zone)[3] : zone
  ]
}

data "scaleway_k8s_cluster" "main" {
  name = local.cluster_name
}

# https://github.com/scaleway/cert-manager-webhook-scaleway
resource "kubernetes_manifest" "cluster_issuer" {
  count = local.enable_cert_manager ? 1 : 0
  manifest = {
    "apiVersion" = "cert-manager.io/v1",
    "kind"       = "ClusterIssuer",
    "metadata" = {
      "name" : "letsencrypt-prod"
    },
    "spec" = {
      "acme" = {
        "email" : "support+letsencrypt@massdriver.cloud"
        "server" : "https://acme-v02.api.letsencrypt.org/directory"
        "privateKeySecretRef" = {
          "name" : "letsencrypt-prod-issuer-account-key"
        },
        "solvers" = concat([for name in local.managed_zones : {
          "selector" = {
            "dnsZones" = [
              trimsuffix(name, ".")
            ]
          },
          "dns01" = {
            "webhook" = {
              "groupName"  = "acme.scaleway.com"
              "solverName" = "scaleway"
            }
          }
          }], [ // could put other solvers here
        ])
      }
    }
  }
  depends_on = [
    helm_release.webhook
  ]
}
