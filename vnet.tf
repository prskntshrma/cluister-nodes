resource "azurerm_virtual_network" "vnet" {
  name                = "vnet"
  address_space       = ["192.168.0.0/16"]
  location            = azurerm_resource_group.k8s-lab.location
  resource_group_name = azurerm_resource_group.k8s-lab.name
}

resource "azurerm_subnet" "subnet" {
  name                 = "default"
  resource_group_name  = azurerm_resource_group.k8s-lab.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["192.168.1.0/24"]

}
