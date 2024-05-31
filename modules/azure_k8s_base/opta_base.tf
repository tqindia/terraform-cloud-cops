resource "helm_release" "cops_base" {
  chart     = "${path.module}/cops-base"
  name      = "cops-base"
  namespace = "default"
  values = [yamlencode({
    tls_key : base64encode(var.private_key),
    tls_crt : base64encode(join("\n", [var.certificate_body, var.certificate_chain])),
    nginxEnabled : var.nginx_enabled
  })]
}