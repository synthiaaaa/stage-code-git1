output "app_service_name" {
  description = "The name of the App Service"
  value       = azurerm_app_service.app_service.name
}

output "app_service_plan_id" {
  description = "The ID of the App Service Plan"
  value       = azurerm_service_plan.app_service_plan.id
}

output "sql_server_name" {
  description = "The name of the SQL Server"
  value       = azurerm_sql_server.sql_server.name
}

output "sql_server_fqdn" {
  description = "The FQDN of the SQL Server"
  value       = azurerm_sql_server.sql_server.fully_qualified_domain_name
}
