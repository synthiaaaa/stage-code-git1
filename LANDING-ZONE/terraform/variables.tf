variable "subscription_id" {
  description = "Azure subscription ID"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "France Central"
}

variable "ops_network_rg" {
  description = "Resource Group for OPS Network"
  type        = string
  default     = "OPS_Network"
}

variable "ops_service_rg" {
  description = "Resource Group for OPS Service"
  type        = string
  default     = "ops-service"
}

