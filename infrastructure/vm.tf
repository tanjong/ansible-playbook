resource "azurerm_resource_group" "devlab_linuxvm_rg" {
  name     = join("_", [local.main, "linuxvm", "rg"])
  location = local.buildregion
}


resource "azurerm_network_interface" "linux_nic" {
  name                = join("_", ["linux", "nic"])
  location            = azurerm_resource_group.devlab_linuxvm_rg.location
  resource_group_name = azurerm_resource_group.devlab_linuxvm_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.application_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.linux_pip.id
  } 
}

resource "azurerm_public_ip" "linux_pip" {
  name                = join("_", ["linux", "pip"])
  location            = azurerm_resource_group.devlab_linuxvm_rg.location
  resource_group_name = azurerm_resource_group.devlab_linuxvm_rg.name
  allocation_method   = "Static"

  tags = local.common_tags
}


resource "azurerm_linux_virtual_machine" "linux_vm" {
  name                = join("-", ["linux", "vm"])
  location            = azurerm_resource_group.devlab_linuxvm_rg.location
  resource_group_name = azurerm_resource_group.devlab_linuxvm_rg.name
  size                = "Standard_D2s_v3"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.linux_nic.id,
  ]

  # connection {
  #   type     = "ssh"
  #   user     = var.user
  #   private_key = file(var.path_privatekey)
  #   host     = "${var.host}"
  # }

  admin_ssh_key {
    username   = "adminuser"
    public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDHUKVp10Js6E+7Co1jpvAzVmwZzE7BqPzRBNtKLBFerigfzVWPHihDRvXhlNhYcbMDidAPjUjh7oZJZb3UvWVMouMX4X+DZAyPo5ESS2csip4OQeQODEE4fDSeDmPg7mvUhfw0RxM7knLzxe8Crvxl/61gn7jGql3ATFbrpTNlZcir9+rgwi40VIYikjvnQuO/JHyFjZvsMXEYMqvclCw5d/aGvmjr35xdhhYBN5bmCzgcBwkyFSdXaKz67VJFX0Nbr8u5Xe/mhD8oxsj1DcZhbI8VWDwAusVWfWaJasPg91bE1bv7Ef2RL9VGiZwIgVdPA7Sp9g18OG/lPuUU/+yglaSw/BGnTHN72EwmmJlrQ+vv5zPkrTwKYCGCmOZSbKjVtsu4TZL2wa6L/2zKTY13SctE0d0P0XH7IikbtVdCgUtqd5EbcLVM7/UdIPsqi0XIOPmIpNjkQr1di1dzqb4etEKq/cqbGfmoK9EqNB9IBCyTrHGdgvU/iC9VXUbAUPE= njiet@LAPTOP-KAMNFCIU"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "20.04-LTS"
    version   = "latest"
  }
}

