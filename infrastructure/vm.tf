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

  connection {
    type     = "ssh"
    user     = var.user
    private_key = file(var.path_privatekey)
    host     = self.public_ip_address
  }

  admin_ssh_key {
    username   = "adminuser"
    public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCuCzWKDX7yq1IYoPgrbLZpgkg8BlOCsEBhPJGjhEVfk2mE0tBtYl4Fadv9tC6w/rq98ZgZIUahVpnJiDEAqLZ+ZqkBAt0mW1YtfqgZ2Q3iV+bgvp5bYktXb8NRU4NRwTSzEYa37eAZr9vNbIGCrifoomsoOmKtCYw0uNzkWBqJixeGakGtA9Umspf3eNwhLz1nzkCq0/jqR3EfbB/Hbdpv1vWKllNPVaVtptuBXtEQwTKFLHOpj0OhcMzZ/naXWzSEhTiN86V6w80Z2cYgshPqoh/mD+NEfCjeARtg+3eSBKb1muJKAoOdmdwm/+1jT3pScNS+1r0MmuPvdZyUQPrdwZsKpGz6BkrfwEOoMduC9791RWVBGVfngXCMEMeqWq57Dfb5d7w+Z4rCf7chNkhQ3Rtnnv8EiyqscYjM4tZKMdAjvEnT9mlwSrNAJhD5Tm01YWh3H9BHrhb3G+VQWKvbakZfwyU3ENn/fmcvsYnwT2KIoyH6jeZ94mY3uIzLg0M= njiet@LAPTOP-KAMNFCIU"
}

provisioner "local-exec" {
  command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u ${var.user} -i '${self.public_ip_address},' --private-key ${var.path_privatekey} ansibleplaybooks/nginx.yml -vv"
}

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}

