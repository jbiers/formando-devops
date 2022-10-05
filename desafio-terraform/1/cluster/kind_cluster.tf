resource "kind_cluster" "cluster" {
    name = "${var.cluster_name}"
    wait_for_ready = true

    kind_config {
      kind        = "Cluster"
      api_version = "kind.x-k8s.io/v1alpha4"

      node {
        role = "control-plane"
        kubeadm_config_patches = var.configs.control_plane
      }

      node {
        role = "worker"
        kubeadm_config_patches = var.configs.infra
      }

      node {
        role = "worker"
        kubeadm_config_patches = var.configs.app
      }
  }
}