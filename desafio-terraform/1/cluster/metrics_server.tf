resource "null_resource" "wait_for_kind_cluster_create" {
  triggers = {
    key = uuid()
  }

  provisioner "local-exec" {
    command = <<EOF
        kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
    EOF
  }

  depends_on = [
    kind_cluster.cluster
  ]
}