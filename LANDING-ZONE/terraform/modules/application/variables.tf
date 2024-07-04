# Variables for Azure App Service
variable "app_service_name" {
  description = "The name of the Azure App Service"
  type        = string
}

variable "location" {
  description = "The location/region where the resources will be created"
  type        = string
  default     = "westeurope"
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "app_service_plan_id" {
  description = "The ID of the App Service Plan"
  type        = string
}

# Variables for Azure App Service Plan
variable "app_service_plan" {
  description = "The name of the App Service Plan"
  type        = string
}

variable "os_type" {
  description = "The OS type of the App Service Plan (Windows/Linux)"
  type        = string
}

variable "sku_name" {
  description = "The SKU name for the App Service Plan"
  type        = string
}

# Variables for Azure SQL Server
variable "sql_server_name" {
  description = "The name of the Azure SQL Server"
  type        = string
}

variable "admin_login" {
  description = "The administrator login for the Azure SQL Server"
  type        = string
}

variable "admin_password" {
  description = "The administrator password for the Azure SQL Server"
  type        = string
  sensitive   = true
}
