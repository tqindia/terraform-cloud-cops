output "load_balancer_raw_ip" {
  value = var.nginx_enabled ? azurerm_public_ip.cops[0].ip_address : ""
}