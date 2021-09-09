# Création VM :
resource "azurerm_linux_virtual_machine" "vm_monitor" {
  name     = "vm-monitor"
  location            = var.location
  resource_group_name = var.rg_name
  size                = "Standard_F2"
  admin_username      = var.LOGINVM
  admin_password = var.PWDVM
  disable_password_authentication = false
  network_interface_ids = [
  azurerm_network_interface.cartereseau-monitor.id
  ]

#   admin_ssh_key {
#     username   = "adminuser"
#     public_key = file("~/.ssh/id_rsa.pub")
#   }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
}

# Carte réseau :
resource "azurerm_network_interface" "cartereseau-monitor" {
  name     = "networkinterface-monitor"
  location            = var.location
  resource_group_name = var.rg_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet_monitor.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Disque managé :
resource "azurerm_managed_disk" "managed_disk_monitor" {
  name     = "managed_disk-monitor"
  location            = var.location
  resource_group_name = var.rg_name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = "1"

}

# Managed disk attach :
resource "azurerm_virtual_machine_data_disk_attachment" "managed_disk_attach_monitor" {
  managed_disk_id    = azurerm_managed_disk.managed_disk_monitor.id
  virtual_machine_id = azurerm_linux_virtual_machine.vm_monitor.id
  lun                = "10"
  caching            = "ReadWrite"
}

///////////////// NETWORK //////////////////////////


# Subnet :
 resource "azurerm_subnet" "subnet_monitor" {
   name           = "subnet_monitor"
   address_prefixes = ["10.0.2.0/24"]
   resource_group_name = var.rg_name
   virtual_network_name = azurerm_virtual_network.vnet-tf.name

 }

#  Associer nsg au subnet :
resource "azurerm_subnet_network_security_group_association" "ng_sbnet_monitor" {
  subnet_id                 = azurerm_subnet.subnet_monitor.id
  network_security_group_id = azurerm_network_security_group.nsg_monitor.id
}


# Network Security group :
resource "azurerm_network_security_group" "nsg_monitor" {
  name     = "nsg-monitor"
  location            = var.location
  resource_group_name = var.rg_name

#   security_rule {
#     name                       = "http"
#     priority                   = 200
#     direction                  = "Inbound"
#     access                     = "Allow"
#     protocol                   = "Tcp"
#     source_port_range          = "*"
#     destination_port_range     = "*"
#     source_address_prefix      = "*"
#     destination_address_prefix = "*"
#   }
}

# Associe network interface aux security goups :
resource "azurerm_network_interface_security_group_association" "nsg_link_monitor" {
  network_interface_id = azurerm_network_interface.cartereseau-monitor.id
  network_security_group_id = azurerm_network_security_group.nsg_monitor.id
}