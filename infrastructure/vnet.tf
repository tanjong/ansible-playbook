resource "azurerm_resource_group" "devlab_general_network_rg" {
  name     = var.devlab_general_network_rg
  location = var.location
}

resource "azurerm_network_security_group" "devlab_nsg" {
  name                = var.devlab_nsg
  location            = azurerm_resource_group.devlab_general_network_rg.location
  resource_group_name = azurerm_resource_group.devlab_general_network_rg.name
}

resource "azurerm_virtual_network" "devlab_vnet" {
  name                = var.devlab_vnet
  location            = azurerm_resource_group.devlab_general_network_rg.location
  resource_group_name = azurerm_resource_group.devlab_general_network_rg.name
  address_space       = var.address_space

  tags = local.common_tags
}

resource "azurerm_route_table" "devlab_rt" {
  name                          = var.devlab_rt
  location                      = azurerm_resource_group.devlab_general_network_rg.location
  resource_group_name           = azurerm_resource_group.devlab_general_network_rg.name
  disable_bgp_route_propagation = var.disable_bgp_route_propagation

  route {
    name           = var.devlab_route1
    address_prefix = var.address_prefix
    next_hop_type  = var.next_hop_type
  }

  tags = local.common_tags
}


resource "azurerm_subnet" "app_subnet" {
  name                 = var.app_subnet
  resource_group_name  = azurerm_resource_group.devlab_general_network_rg.name
  virtual_network_name = azurerm_virtual_network.devlab_vnet.name
  address_prefixes     = var.address_prefixes_app
}

resource "azurerm_subnet_route_table_association" "devlab_rt_appl_assoc" {
  subnet_id      = azurerm_subnet.app_subnet.id
  route_table_id = azurerm_route_table.devlab_rt.id
}

resource "azurerm_subnet_network_security_group_association" "devlab_nsg_app_subnet_assoc" {
  subnet_id                 = azurerm_subnet.app_subnet.id
  network_security_group_id = azurerm_network_security_group.devlab_nsg.id
}
