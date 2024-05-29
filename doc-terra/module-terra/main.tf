# main.tf

module "custom_subnet" {
  source = "./modules/subnet"

  subnet_name        = "custom-subnet"
  subnet_cidr_block  = "10.0.2.0/24"
  virtual_network_name = "virtual-machine-vnet"  # Remplacez ceci par le nom de votre réseau virtuel existant
}
