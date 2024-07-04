# Outputs
output "sql_server_01" {
  value = azurerm_mssql_server.sql_server_01
  sensitive = true
}

output "sql_server_02" {
  value = azurerm_mssql_server.sql_server_02
  sensitive = true
}

output "subnet_ids" {
  value = azurerm_subnet.subnet_app[*].id
}