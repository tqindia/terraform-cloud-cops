resource "azurerm_network_security_group" "cops" {
  name                = "cops-${var.env_name}-default"
  location            = data.azurerm_resource_group.cops.location
  resource_group_name = data.azurerm_resource_group.cops.name
}

resource "azurerm_network_security_rule" "internal" {
  network_security_group_name = azurerm_network_security_group.cops.name
  resource_group_name         = data.azurerm_resource_group.cops.name
  name                        = "internal"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_address_prefix       = var.private_ipv4_cidr_block
  source_port_range           = "*"
  destination_port_range      = "*"
  destination_address_prefix  = var.private_ipv4_cidr_block
}

resource "azurerm_network_security_rule" "allowoutbound" {
  network_security_group_name = azurerm_network_security_group.cops.name
  resource_group_name         = data.azurerm_resource_group.cops.name
  name                        = "allowoutbound"
  priority                    = 100
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_address_prefix       = var.private_ipv4_cidr_block
  source_port_range           = "*"
  # ignore since outbound is ok - e.g. connecting to 3rd party saas services
  #tfsec:ignore:azure-network-no-public-egress
  destination_address_prefix = "0.0.0.0/0"
  destination_port_range     = "*"
}

resource "azurerm_subnet_network_security_group_association" "cops" {
  subnet_id                 = azurerm_subnet.cops.id
  network_security_group_id = azurerm_network_security_group.cops.id
}