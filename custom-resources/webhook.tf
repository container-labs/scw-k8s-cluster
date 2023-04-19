locals {
  helm_additional_values = {
    certManager = {
      namespace = "md-core-services"
    }
    secret = {
      accessKey = var.scw_authentication.data.access_key
      secretKey = var.scw_authentication.data.secret_key
    }
  }
}

resource "helm_release" "webhook" {
  name              = "scw-webhook"
  chart             = "${path.module}/scaleway-webhook"
  namespace         = "md-core-services"
  create_namespace  = true
  force_update      = true
  dependency_update = true

  values = [
    fileexists("${path.module}/scaleway-webhook/values.yaml") ? file("${path.module}/scaleway-webhook/values.yaml") : "",
    yamlencode(local.helm_additional_values)
  ]
}
