# https://registry.terraform.io/providers/scaleway/scaleway/latest/docs/resources/k8s_cluster

resource "scaleway_k8s_cluster" "main" {
  name    = var.md_metadata.name_prefix
  version = var.kubernetes_version
  region  = var.region
  cni     = "calico"
  tags    = [for k, v in var.md_metadata.default_tags : "${k}::${v}"]

  autoscaler_config {
    disable_scale_down              = false
    scale_down_delay_after_add      = "5m"
    estimator                       = "binpacking"
    expander                        = "random"
    ignore_daemonsets_utilization   = true
    balance_similar_node_groups     = true
    expendable_pods_priority_cutoff = -5
  }
}

resource "scaleway_k8s_pool" "main" {
  for_each    = { for group in var.node_groups : group.name => group }
  cluster_id  = scaleway_k8s_cluster.main.id
  name        = each.value.name
  tags        = [for k, v in var.md_metadata.default_tags : "${k}::${v}"]
  node_type   = each.value.machine_type
  size        = each.value.min_size
  autoscaling = true
  autohealing = true
  min_size    = each.value.min_size
  max_size    = each.value.max_size

  lifecycle {
    create_before_destroy = true
  }
}
