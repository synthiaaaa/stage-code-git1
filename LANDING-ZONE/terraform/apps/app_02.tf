module "app_02" {
  source              = "../modules/application"
  app_service_name    = "app02-service"
  app_service_plan_id = var.app_service_plan_id
  sql_server_name     = "app02-sql"
  admin_login         = var.admin_login
  admin_password      = var.admin_password
  resource_group_name = var.resource_group_name
  location            = var.location
}