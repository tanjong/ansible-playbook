#RULES FOR LINUX SERVERS
resource "azurerm_network_security_rule" "Linux" {
  name                        = var.linux
  priority                    = 101
  direction                   = var.direction
  access                      = var.access
  protocol                    = var.protocol
  source_port_range           = var.source_port_range
  destination_port_range      = var.destination_port_range
  source_address_prefix       = var.source_address_prefix
  destination_address_prefix  = var.destination_address_prefix
  resource_group_name         = azurerm_resource_group.devlab_general_network_rg.name
  network_security_group_name = azurerm_network_security_group.devlab_nsg.name
}


