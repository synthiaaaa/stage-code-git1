output "app_service_id" {
  value = azurerm_app_service.app_service.id
}

output "service_plan_id" {
  value = azurerm_service_plan.service_plan.id
}

output "sql_server_id" {
  value = azurerm_sql_server.sql_server.id
}

output "sql_server_fqdn_01" {
  value = azurerm_sql_server.sql_server_01.fully_qualified_domain_name
}

output "sql_server_fqdn_02" {
  value = azurerm_sql_server.sql_server_02.fully_qualified_domain_name
}