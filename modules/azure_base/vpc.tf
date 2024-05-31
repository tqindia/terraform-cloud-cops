resource "azurerm_virtual_network" "cops" {
  name                = "cops-${var.env_name}"
  location            = data.azurerm_resource_group.cops.location
  resource_group_name = data.azurerm_resource_group.cops.name
  address_space       = [var.private_ipv4_cidr_block]
}

resource "azurerm_subnet" "cops" {
  name                                           = "cops-${var.env_name}-subnet"
  resource_group_name                            = data.azurerm_resource_group.cops.name
  virtual_network_name                           = azurerm_virtual_network.cops.name
  address_prefixes                               = [var.subnet_ipv4_cidr_block]
  enforce_private_link_endpoint_network_policies = true
}