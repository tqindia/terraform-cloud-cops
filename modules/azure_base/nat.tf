resource "azurerm_public_ip" "cops" {
  name                = "cops-${var.env_name}-nat-public-ip"
  location            = data.azurerm_resource_group.cops.location
  resource_group_name = data.azurerm_resource_group.cops.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_public_ip_prefix" "cops" {
  name                = "cops-${var.env_name}-nat-public-ip-prefix"
  location            = data.azurerm_resource_group.cops.location
  resource_group_name = data.azurerm_resource_group.cops.name
  prefix_length       = 30
}

resource "azurerm_nat_gateway" "cops" {
  name                    = "cops-${var.env_name}-nat-gateway"
  location                = data.azurerm_resource_group.cops.location
  resource_group_name     = data.azurerm_resource_group.cops.name
  sku_name                = "Standard"
  idle_timeout_in_minutes = 10
}

resource "azurerm_nat_gateway_public_ip_prefix_association" "cops" {
  nat_gateway_id      = azurerm_nat_gateway.cops.id
  public_ip_prefix_id = azurerm_public_ip_prefix.cops.id
}

resource "azurerm_nat_gateway_public_ip_association" "cops" {
  nat_gateway_id       = azurerm_nat_gateway.cops.id
  public_ip_address_id = azurerm_public_ip.cops.id
}

resource "azurerm_subnet_nat_gateway_association" "cops" {
  subnet_id      = azurerm_subnet.cops.id
  nat_gateway_id = azurerm_nat_gateway.cops.id
}
