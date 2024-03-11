resource "helm_release" "grafana" {
  count           = var.grafana_enabled ? 1 : 0
  chart           = "grafana-k8s-monitoring"
  name            = "grafana-k8s-monitoring"
  repository      = "https://grafana.github.io/helm-charts"
  namespace       = "grafana"
  version         = "0.36.0"
  atomic          = true
  cleanup_on_fail = true
  values = [
    yamlencode({
      serviceAccount : {
        create : true
      }
    })
  ]
}
