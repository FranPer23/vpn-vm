# Create Pdc01 into Vnet1 first subnet
data "azurerm_resource_group" "pdc02RG"{
    name        = azurerm_resource_group.rg.name  
}

data "azurerm_virtual_network" "pdc02vnet" {
  name = azurerm_virtual_network.secondvnet.name
  resource_group_name = data.azurerm_resource_group.pdc02RG.name
}
data "azurerm_subnet" "pdc02Sub" {
  name = azurerm_subnet.secondvnetsub1.name
  resource_group_name = data.azurerm_resource_group.pdc02RG.name
  virtual_network_name = data.azurerm_virtual_network.pdc02vnet.name
}
# Create public IPs
resource "azurerm_public_ip" "pdc02Piptf" {
    name                         = "pdc02pip"
    location                     = data.azurerm_virtual_network.pdc02vnet.location
    resource_group_name          = data.azurerm_resource_group.pdc02RG.name
    allocation_method            = "Dynamic"

}

# Create Network Security Group and rule
resource "azurerm_network_security_group" "pdc02nsgtf" {
    name                = "pdc02NSG"
    location            = data.azurerm_virtual_network.pdc02vnet.location
    resource_group_name = data.azurerm_resource_group.pdc02RG.name

    security_rule {
        name                       = "AllowRDP"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "3389"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }

}
# Create Pdc01 NIC
resource "azurerm_network_interface" "pdc02nictf" {
  name                = "pdc02nic"
  location            = data.azurerm_virtual_network.pdc02vnet.location
  resource_group_name = data.azurerm_resource_group.pdc02RG.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.pdc02Sub.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pdc02Piptf.id
  }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "urca" {
  network_interface_id      = azurerm_network_interface.pdc02nictf.id
  network_security_group_id = azurerm_network_security_group.pdc02nsgtf.id
}
# Create Pdc01
resource "azurerm_windows_virtual_machine" "pdc02vmtf" {
  name                = "Pdc02"
  location            = data.azurerm_virtual_network.pdc02vnet.location
  resource_group_name = data.azurerm_resource_group.pdc02RG.name
  size                = "Standard_B2ms"
  admin_username      = "sadmin"
  admin_password      = data.azurerm_key_vault_secret.myabsolutesecret.value
  network_interface_ids = [
    azurerm_network_interface.pdc02nictf.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
}
#Export public IP By Cosimo
data "azurerm_public_ip" "pdc02publicip" {
  name                = azurerm_public_ip.pdc02Piptf.name
  resource_group_name = data.azurerm_resource_group.pdc02RG.name
  depends_on          = [azurerm_windows_virtual_machine.pdc02vmtf]
}
output "pdc02_public_ip_address" {
  value = data.azurerm_public_ip.pdc02publicip.ip_address
}