variable "devlab_general_network_rg" {
  type    = string
  default = "devlab_general_network_rg"
}

variable "location" {
  type    = string
  default = "Central US"
}

variable "devlab_nsg" {
  type    = string
  default = "devlab_nsg"
}

variable "devlab_vnet" {
  type    = string
  default = "devlab_vnet"
}

variable "address_space" {
  type    = list(string)
  default = ["10.0.0.0/16"]
}

variable "devlab_rt" {
  type    = string
  default = "devlab_rt"
}

variable "devlab_route1" {
  type    = string
  default = "devlab_route1"
}

variable "address_prefix" {
  type    = string
  default = "10.1.0.0/16"
}

variable "next_hop_type" {
  type    = string
  default = "VnetLocal"
}

variable "disable_bgp_route_propagation" {
  type    = string
  default = "false"
}

variable "app" {
  type    = string
  default = "app"
}


variable "address_prefixes" {
  type    = list(string)
  default = ["10.0.1.0/24"]
}

variable "linux" {
  type    = string
  default = "linux"
}

variable "direction" {
  type    = string
  default = "Inbound"
}

variable "access" {
  type    = string
  default = "Allow"
}

variable "protocol" {
  type    = string
  default = "Tcp"
}

variable "source_port_range" {
  type    = string
  default = "*"
}

variable "destination_port_range" {
  type    = string
  default = "22"
}

variable "source_address_prefix" {
  type    = string
  default = "75.28.18.240/32"
}

variable "destination_address_prefix" {
  type    = string
  default = "VirtualNetwork"
}
