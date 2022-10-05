variable "kubernetes_version" {
    type = string
    description = "Kubernetes version"
    default = "v1.16.1"
}

variable "cluster_name" {
    type = string
    description = "Cluster name"
    default = "my-cluster"
}

variable "configs" {
    default = {
        control_plane : []

        infra : [
        <<-EOT
          kind: JoinConfiguration
          nodeRegistration:
            taints:
            - key: "dedicated"
              value: "infra"
              effect: "NoSchedule"
            kubeletExtraArgs:
              node-labels: "role=infra"
        EOT
        ]

        app : [
        <<-EOT
        kind: JoinConfiguration
        nodeRegistration:
            kubeletExtraArgs:
            node-labels: "role=app"
        EOT
        ]
    }
}