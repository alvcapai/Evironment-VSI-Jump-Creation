data "ibm_resource_group" "rg" {
  name = var.resource_group
}

locals {
  tags = toset(concat(var.default_tags, ["Project:rackware-migration"]))
}

module "vpc" {
  source             = "./modules/vpc"
  create_vpc         = var.create_vpc
  existing_vpc_name  = var.existing_vpc_name
  vpc_name           = var.vpc_name
  subnet_cidr        = var.subnet_cidr
  zone               = var.zone
  allowed_admin_cidr = var.allowed_admin_cidr
  resource_group_id  = data.ibm_resource_group.rg.id
  tags               = local.tags
}

module "sap_vsi" {
  source              = "./modules/sap_vsi"
  instance_name       = var.sap_instance_name
  vpc_id              = module.vpc.vpc_id
  subnet_id           = module.vpc.subnet_id
  zone                = var.zone
  resource_group_id   = data.ibm_resource_group.rg.id
  sap_image_regex     = var.sap_image_regex
  ssh_key_name        = var.ssh_key_name
  ssh_public_key      = var.ssh_public_key
  profile             = var.sap_profile
  boot_volume_size    = var.sap_boot_volume_size
  security_group_ids  = [module.vpc.security_group_id]
  tags                = local.tags
}

module "cos_images" {
  source                  = "./modules/cos_images"
  resource_group_id       = data.ibm_resource_group.rg.id
  region                  = var.region
  cos_instance_name       = var.cos_instance_name
  cos_plan                = var.cos_plan
  cos_location            = var.cos_location
  bucket_name             = var.cos_bucket_name
  enable_custom_image     = var.enable_custom_image
  custom_image_file       = var.custom_image_file
  custom_image_object_key = var.custom_image_object_key
  tags                    = local.tags
}

module "custom_image_import" {
  count             = var.enable_custom_image ? 1 : 0
  source            = "./modules/custom_image_import"
  resource_group_id = data.ibm_resource_group.rg.id
  custom_image_name = var.custom_image_name
  cos_instance_id   = module.cos_images.cos_instance_id
  image_href        = module.cos_images.image_href
  tags              = local.tags
}
