resource "helm_release" "nvidia_daemonset" {
  namespace       = "kube-system"
  chart           = "nvidia-device-plugin"
  name            = "nvidia-device-plugin"
  repository      = "https://nvidia.github.io/k8s-device-plugin"
  version         = "0.14.0"
  atomic          = true
  cleanup_on_fail = true
  values = [
    yamlencode({
      affinity : {
        nodeAffinity : {
          requiredDuringSchedulingIgnoredDuringExecution : {
            nodeSelectorTerms : [
              {
                matchExpressions : [
                  {
                    key : "ami_type"
                    operator : "In"
                    values : ["AL2_x86_64_GPU"]
                  }
                ]
              }
            ]
          }
        }
      },
      tolerations : [
        {
          operator : "Exists"
        }
      ]
    })
  ]
}
