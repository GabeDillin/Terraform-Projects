output "vm_id" {
  description = "The ID of the virtual machine."
  value       = azurerm_linux_virtual_machine.vm.id
}

output "vm_ip_address" {
  description = "The private IP address of the virtual machine."
  value       = azurerm_network_interface.vm_nic.private_ip_address
}
