module "network" {
  source      = "./modules/network"
  vpc_name    = lower(var.vpc_name)
  vpc_cidr    = var.vpc_cidr
  public_cidr = var.public_cidr
  public_az   = lower(var.public_az)

}

module "database" {
  source          = "./modules/database"
  table_names     = var.table_names
  db_billing_mode = upper(var.db_billing_mode)
}

module "security" {
  source = "./modules/security"
  vpc_id = module.network.vpc_id
}

module "application" {
  source       = "./modules/application"
  lab_role_arn = var.lab_role_arn
}

module "compute" {
  source              = "./modules/compute"
  lab_role_arn        = var.lab_role_arn
  api_gateway_url     = module.application.api_gateway_url
  container_image_url = var.container_image_url
}