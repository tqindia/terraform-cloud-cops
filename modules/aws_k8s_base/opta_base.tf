resource "helm_release" "cops_base" {
  chart     = "${path.module}/cops-base"
  name      = "cops-base"
  namespace = "default"
  values = [
    yamlencode({
      adminArns : var.admin_arns
      nginxEnabled : var.nginx_enabled
    })
  ]
  depends_on = [
    time_sleep.wait_a_bit
  ]
}

resource "time_sleep" "wait_a_bit" {
  depends_on = [
    helm_release.autoscaler,
    helm_release.load_balancer
  ]

  create_duration = "30s"
}