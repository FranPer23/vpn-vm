# Create Pdc01 into Vnet1 first subnet
data "azurerm_resource_group" "myRG1"{
    name        = azurerm_resource_group.rg.name  
}

data "azurerm_virtual_network" "myvnet" {
  name = azurerm_virtual_network.firstvnet.name
  resource_group_name = data.azurerm_resource_group.myRG1.name
}
data "azurerm_subnet" "mySub" {
  name = azurerm_subnet.firstvnetsub1.name
  resource_group_name = data.azurerm_resource_group.myRG1.name
  virtual_network_name = data.azurerm_virtual_network.myvnet.name
}
# Create public IPs
resource "azurerm_public_ip" "Pdc01Piptf" {
    name                         = "pdc01pip"
    location                     = data.azurerm_virtual_network.myvnet.location
    resource_group_name          = data.azurerm_resource_group.myRG1.name
    allocation_method            = "Dynamic"

}

# Create Network Security Group and rule
resource "azurerm_network_security_group" "pdc01nsgtf" {
    name                = "pdc01NSG"
    location            = data.azurerm_virtual_network.myvnet.location
    resource_group_name = data.azurerm_resource_group.myRG1.name

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
resource "azurerm_network_interface" "pdc01nic" {
  name                = "pdc01NIC"
  location            = data.azurerm_virtual_network.myvnet.location
  resource_group_name = data.azurerm_resource_group.myRG1.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.mySub.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.Pdc01Piptf.id
  }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "hoihoi" {
  network_interface_id      = azurerm_network_interface.pdc01nic.id
  network_security_group_id = azurerm_network_security_group.pdc01nsgtf.id
}
# Create Pdc01
resource "azurerm_windows_virtual_machine" "pdc01vmtf" {
  name                = "Pdc01"
  location            = data.azurerm_virtual_network.myvnet.location
  resource_group_name = data.azurerm_resource_group.myRG1.name
  size                = "Standard_B2ms"
  admin_username      = "sadmin"
  admin_password      = data.azurerm_key_vault_secret.myabsolutesecret.value
  network_interface_ids = [
    azurerm_network_interface.pdc01nic.id,
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
data "azurerm_public_ip" "myterraformpublicip" {
  name                = azurerm_public_ip.Pdc01Piptf.name
  resource_group_name = data.azurerm_resource_group.myRG1.name
  depends_on          = [azurerm_windows_virtual_machine.pdc01vmtf]
}
output "public_ip_address" {
  value = data.azurerm_public_ip.myterraformpublicip.ip_address
}