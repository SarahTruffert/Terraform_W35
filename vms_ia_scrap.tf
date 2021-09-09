# Création vm :
resource "azurerm_linux_virtual_machine" "vms" {
  for_each = var.vm_names
  name     = "vm-${each.key}"
  location            = var.location
  resource_group_name = var.rg_name
  size                = "Standard_F2"
  admin_username      = var.LOGINVM
  admin_password = var.PWDVM
  disable_password_authentication = false
  network_interface_ids = [
  azurerm_network_interface.cartereseau[each.key].id
  ]

# Clef SSH :
  admin_ssh_key {
    username   = var.LOGINVM
    public_key = file("key/key.pub")
  }

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
resource "azurerm_network_interface" "cartereseau" {
  for_each = var.vm_names
  name     = "networkinterface-${each.key}"
  location            = var.location
  resource_group_name = var.rg_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet_vm.id
    private_ip_address_allocation = "Dynamic"
  }
}


# Disque managé :
resource "azurerm_managed_disk" "managed_disk" {
  for_each = var.vm_names
  name     = "managed_disk-${each.key}"
  location            = var.location
  resource_group_name = var.rg_name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = "1"

}

# Managed disk attach :
resource "azurerm_virtual_machine_data_disk_attachment" "managed_disk_attach" {
  for_each = var.vm_names
  managed_disk_id    = azurerm_managed_disk.managed_disk[each.key].id
  virtual_machine_id = azurerm_linux_virtual_machine.vms[each.key].id
  lun                = "10"
  caching            = "ReadWrite"
}


///////////////// NETWORK //////////////////////////

# Subnet :
resource "azurerm_subnet" "subnet_vm" {
    name           = "subnet_vm"
    address_prefixes = ["10.0.1.0/24"]
    resource_group_name = var.rg_name
    virtual_network_name = azurerm_virtual_network.vnet-tf.name
  }

#  Associer nsg au subnet :
#resource "azurerm_subnet_network_security_group_association" "ng_sbnet" {
#  for_each = toset(var.vm_names)
#  subnet_id                 = azurerm_subnet.subnet_vm.id
#  network_security_group_id = azurerm_network_security_group.nsg[each.key].id
#}

# Network Security group :
resource "azurerm_network_security_group" "nsg" {
  for_each = var.vm_names
  name     = "nsg-${each.key}"
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
resource "azurerm_network_interface_security_group_association" "nsg_link" {
  for_each = toset(var.vm_names)
  network_interface_id = azurerm_network_interface.cartereseau[each.key].id
  network_security_group_id = azurerm_network_security_group.nsg[each.key].id
}