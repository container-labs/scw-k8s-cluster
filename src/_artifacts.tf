

# locals {
#   data_authentication = {
#     cluster = {
#       server = null_resource.kubeconfig.triggers.host
#       certificate-authority-data = base64decode(
#         null_resource.kubeconfig.triggers.cluster_ca_certificate
#       )
#     }
#     user = {
#       token = null_resource.kubeconfig.triggers.token
#     }
#   }

#   data_infrastructure = {
#     id = scaleway_k8s_cluster.main.id
#   }

#   artifact = {
#     data = {
#       authentication = local.data_authentication
#       infrastructure = local.data_infrastructure
#     }
#     specs = {
#       kubernetes = {
#         cloud   = "scw"
#         version = var.kubernetes_version
#       }
#     }
#   }
# }

# resource "null_resource" "kubeconfig" {
#   depends_on = [scaleway_k8s_pool.main] # at least one pool here
#   triggers = {
#     host                   = scaleway_k8s_cluster.main.kubeconfig[0].host
#     token                  = scaleway_k8s_cluster.main.kubeconfig[0].token
#     cluster_ca_certificate = scaleway_k8s_cluster.main.kubeconfig[0].cluster_ca_certificate
#   }
# }

# resource "massdriver_artifact" "kubernetes_cluster" {
#   field                = "kubernetes_cluster"
#   provider_resource_id = scaleway_k8s_cluster.main.id
#   name                 = "a contextual name for the artifact"
#   artifact             = jsonencode(local.artifact)
# }



# # locals {
# #   cacert_base64   = data.aws_eks_cluster.cluster.certificate_authority[0].data
# #   oidc_issuer_url = data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer

# #   data_authentication = {
# #     cluster = {
# #       server                     = data.aws_eks_cluster.cluster.endpoint
# #       certificate-authority-data = local.cacert_base64
# #     }
# #     // We need to set the "user" here, but the token won't be generated til the next step
# #     user = {
# #       token = lookup(data.kubernetes_secret.massdriver-cloud-provisioner_service-account_secret.data, "token")
# #     }
# #   }
# #   data_infrastructure = {
# #     arn             = data.aws_eks_cluster.cluster.arn
# #     oidc_issuer_url = local.oidc_issuer_url
# #   }
# #   specs_kubernetes = {
# #     cloud            = "aws"
# #     distribution     = "eks"
# #     version          = data.aws_eks_cluster.cluster.version
# #     platform_version = data.aws_eks_cluster.cluster.platform_version
# #   }
# #   specs_scw = {
# #     service  = "eks"
# #     resource = "cluster"
# #     region   = var.vpc.specs.aws.region
# #   }

# #   kubernetes_cluster_artifact = {
# #     data = {
# #       infrastructure = local.data_infrastructure
# #       authentication = local.data_authentication
# #     }
# #     specs = {
# #       kubernetes = local.specs_kubernetes
# #     }
# #   }
# # }
