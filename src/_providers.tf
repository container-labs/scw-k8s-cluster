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
    null = {
      source = "hashicorp/null"
    }
  }
}

provider "scaleway" {
  access_key = var.scw_authentication.data.access_key
  secret_key = var.scw_authentication.data.secret_key
  project_id = var.scw_authentication.data.project_id
}
