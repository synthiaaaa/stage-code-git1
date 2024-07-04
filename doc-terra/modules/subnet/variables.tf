# modules/subnet/variables.tf

variable "subnet_name" {
  description = "Nom du sous-réseau"
  type        = string
}

variable "subnet_cidr_block" {
  description = "Bloc CIDR du sous-réseau"
  type        = string
}

variable "virtual_network_name" {
  description = "Nom du réseau virtuel"
  type        = string
}
