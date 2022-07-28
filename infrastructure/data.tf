# ----- Run Userdata ----- ##
data "cloudinit_config" "shell" {
  gzip          = false
  base64_encode = false

  part {
    content_type = "text/x-shellscript"
    filename     = "script"
    content = templatefile("./scripts/script.sh",

      {
        vmip = azurerm_linux_virtual_machine.linux_vm.public_ip_address
        path = var.path_privatekey
    })
  }
}