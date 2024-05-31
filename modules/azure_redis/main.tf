resource "random_id" "key_suffix" {
  byte_length = 8
}

resource "azurerm_redis_cache" "cops" {
  name                          = "cops-${var.layer_name}-${var.module_name}-${random_id.key_suffix.hex}"
  location                      = data.azurerm_resource_group.main.location
  resource_group_name           = data.azurerm_resource_group.main.name
  capacity                      = var.capacity
  family                        = var.family
  sku_name                      = var.sku_name
  public_network_access_enabled = false
  enable_non_ssl_port           = false
  minimum_tls_version           = "1.2"

  redis_configuration {}
}

resource "azurerm_private_endpoint" "cops" {
  name                = "cops-${var.layer_name}-${var.module_name}"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  subnet_id           = data.azurerm_subnet.cops.id

  private_service_connection {
    name                           = "cops-${var.layer_name}-${var.module_name}-${random_id.key_suffix.hex}"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_redis_cache.cops.id
    subresource_names              = ["redisCache"]
  }
}
