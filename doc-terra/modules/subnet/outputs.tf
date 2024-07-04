# modules/subnet/outputs.tf

output "subnet_id" {
  description = "ID du sous-réseau créé ou modifié"
  value       = azurerm_subnet.subnet.id
}
