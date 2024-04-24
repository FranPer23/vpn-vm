# Create 2 vnet into a resource group already created
data "azurerm_resource_group" "myRG"{
    name        = azurerm_resource_group.rg.name
    
}

#####################################################################
# crete first virtual network and two subnets
#####################################################################
resource "azurerm_virtual_network" "firstvnet" {
  name          = var.first_vnet
  location      = var.first_vnet_location
  address_space = [var.first_vnet_AddressSpace]
  resource_group_name = azurerm_resource_group.rg.name
}
# subnet 1
resource "azurerm_subnet" "firstvnetsub1" {
  name = var.first_vnet_sub1_name
  resource_group_name = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.firstvnet.name
  address_prefixes = [ var.first_vnet_sub1_AddressSpace ]
}
# subnet 2
resource "azurerm_subnet" "firstvnetsub2" {
  name = var.first_vnet_sub2_name
  resource_group_name = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.firstvnet.name
  address_prefixes = [ var.first_vnet_sub2_AddressSpace ]
}

#####################################################################
# crete second virtual network and one subnet
#####################################################################
resource "azurerm_virtual_network" "secondvnet" {
  name  = var.second_vnet
  address_space = [var.second_vnet_AddressSpace]
  location = var.second_vnet_location
  resource_group_name=  azurerm_resource_group.rg.name
}
# subnet 1
resource "azurerm_subnet" "secondvnetsub1" {
  name = var.second_vnet
  resource_group_name = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.secondvnet.name
  address_prefixes = [ var.secod_vnet_sub1_AddressSpace ]
}