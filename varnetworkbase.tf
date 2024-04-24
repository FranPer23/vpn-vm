# First Virtual Network
variable "first_vnet" {
    default = "VNet01"
    description ="Name of first Virtual network"
}

variable "first_vnet_AddressSpace" {
    default = "10.10.0.0/16"
    description = "Addres space of first virtual network"
}

variable "first_vnet_location"{
    default = "eastus"
}
# First Virtual Network Subnets
variable "first_vnet_sub1_name" {
    default = "Pdc01Sub"
    description ="Name of the first subnet into first Virtual network"
}

variable "first_vnet_sub1_AddressSpace" {
    default = "10.10.0.0/24"
    description = "Addres space of first subnet into first virtual network"
}
# Second Virtual Network Subnets for VPN Gateway
variable "first_vnet_sub2_name" {
    default = "GatewaySubnet"
    description ="Name of the VPN Gateway subnet into first Virtual network"
}

variable "first_vnet_sub2_AddressSpace" {
    default = "10.10.255.0/27"
    description = "Addres space for Gateway VPN subnet into first virtual network"
}

# Second Virtual Network
variable "second_vnet" {
    default = "VNet02"
    description ="Name of second Virtual network"
}

variable "second_vnet_AddressSpace" {
    default = "10.20.0.0/16"
    description = "Addres space of second virtual network"
}

variable "second_vnet_location"{
    default = "eastus2"
    description=  "location for second virtul network"
}

variable "secod_vnet_sub1_AddressSpace" {
    default = "10.20.0.0/24"
    description = "Addres space for 1 subnet into second virtual network"
}