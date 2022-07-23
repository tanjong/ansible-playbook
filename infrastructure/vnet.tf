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

resource "azurerm_route" "route" {
  name                = "route1"
  resource_group_name = azurerm_resource_group.devlab_general_network_rg.name
  route_table_name    = azurerm_route_table.devlab_rt.name
  address_prefix      = "10.0.0.0/16"
  next_hop_type       = "VnetLocal"
}

resource "azurerm_route_table" "devlab_rt" {
  name                = var.devlab_rt
  location            = azurerm_resource_group.devlab_general_network_rg.location
  resource_group_name = azurerm_resource_group.devlab_general_network_rg.name
}

resource "azurerm_subnet" "application_subnet" {
  name                 = var.application_subnet
  resource_group_name  = azurerm_resource_group.devlab_general_network_rg.name
  virtual_network_name = azurerm_virtual_network.devlab_vnet.name
  address_prefixes     = var.address_prefixes_application
}

resource "azurerm_subnet_route_table_association" "elitedev_rtb_assoc_application" {
  subnet_id      = azurerm_subnet.application_subnet.id
  route_table_id = azurerm_route_table.devlab_rt.id
}

resource "azurerm_subnet_network_security_group_association" "devlab_nsg_assoc_application_subnet" {
  subnet_id                 = azurerm_subnet.application_subnet.id
  network_security_group_id = azurerm_network_security_group.devlab_nsg.id
}