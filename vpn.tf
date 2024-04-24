#------------------------------------------------------------------------------
# Create P2S VPN Gateway connections - certificate authentication 
# Use objects and variables created by main and networkbase 
# but for reuse it recall all resourse needded using a data block
# The VPN Gateway will be deployed into VNet01 GatewaySubnet
#------------------------------------------------------------------------------
data "azurerm_resource_group" "vpnRG"{
    name        = azurerm_resource_group.rg.name  
}

data "azurerm_virtual_network" "vpnvnet" {
  name = azurerm_virtual_network.firstvnet.name
  resource_group_name = data.azurerm_resource_group.vpnRG.name
}
data "azurerm_subnet" "vpnsub" {
  name = azurerm_subnet.firstvnetsub2.name
  resource_group_name = data.azurerm_resource_group.vpnRG.name
  virtual_network_name = data.azurerm_virtual_network.vpnvnet.name
}
# Create Public IP for VPN Gateway 
resource "azurerm_public_ip" "vpnPiptf" {
    name                         = "vpnpip"
    location                     = data.azurerm_virtual_network.vpnvnet.location
    resource_group_name          = data.azurerm_resource_group.vpnRG.name
    allocation_method            = "Dynamic"

}

# Crete VPN Gateway
resource "azurerm_virtual_network_gateway" "vpngateway" {
  name                = "VNet1GW"
  location            = data.azurerm_virtual_network.myvnet.location
  resource_group_name = data.azurerm_virtual_network.myvnet.resource_group_name

  type     = "Vpn"
  vpn_type = "RouteBased"

  active_active = false
  enable_bgp    = false
  sku           = "VpnGw2"
  generation    = "Generation2"

  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.vpnPiptf.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = data.azurerm_subnet.vpnsub.id
  }

  vpn_client_configuration {
    address_space = ["172.16.101.0/24"]

    root_certificate {
      name = "p2s-jvn-root-cert"

      public_cert_data = <<EOF
      MIIC5zCCAc+gAwIBAgIQF8uVKQEJIYBMFI8ffAEL9jANBgkqhkiG9w0BAQsFADAW
MRQwEgYDVQQDDAtQMlNSb290Q2VydDAeFw0yNDA0MTIxMTQ1MDdaFw0yNjA0MTIx
MTU1MDdaMBYxFDASBgNVBAMMC1AyU1Jvb3RDZXJ0MIIBIjANBgkqhkiG9w0BAQEF
AAOCAQ8AMIIBCgKCAQEAvppVDePKkL1rqgIRB0fFPdHUxGi65qiAG6daeKF/4B7f
BpG1dwXUYnX3+YDRhoCMGP4c6BmAjQXg6L0nq/2+wXLNXZP+U3BpTcZT89PhRmar
mKJ10IQQqBb6CSMiUa3eHO/g8h9JXuhH00wrlQq94VzuenXHKtNDxb44w8KPe9jQ
9wBA+97Nf/MpDL42ksgDQ6zl39O030/iB48SeZZBeBD4SPG66148rg68zUTIVv7V
aq30gjUOYN6iTGU46ZD/z04M7CuX5pZGYyYPYGqrNwruqmtC4GMWnMy/mALcC6zF
8ecrUpJQdgnonsrHUuu163Qa/JSJlKjGdQJCAJPNPQIDAQABozEwLzAOBgNVHQ8B
Af8EBAMCAgQwHQYDVR0OBBYEFHiQq4h6mEAjWtrs680qh4ckZFhtMA0GCSqGSIb3
DQEBCwUAA4IBAQCfXMG01Es+DxzVjmpzXbIGMqxBsyG3Q7wWyuFd8xmgJjjxoZBG
D8DoljJ7L9QHpsE+HYF0UqV0MHWc5or7LIzjhyIwFV4+OWk7slTzFPkiQuaI4SL8
JBiQc+2h1eFUHlqGhKUdumh1Q0lSQSmo0kfe/nN0ajMOjJ2HBEsPyem/xPbSCmOv
e3DjjzECHPkNf3BJNz1UG6uvA5qRwpcImBoEx5ERsGeUO/uLnwOtMDSmFg47swhM
Twn6fUc3ouRPmd+f1qAKGU/R6G369qurUJ+XPjpp+Js3NCvkX1iX3gHMpbjG5sel
Kmxqp4uX6J7lbmkF0cPcpSyasuQRNaWXhMXr

EOF
    }
  }
}