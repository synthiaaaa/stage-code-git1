variable "app_service_plan_id" {
  description = "ID of the App Service Plan"
  type        = string
}

variable "admin_login" {
  description = "SQL Server admin login"
  type        = string
}

variable "admin_password" {
  description = "SQL Server admin password"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "location" {
  description = "Azure location"
  type        = string
  default     = "France Central"
}
