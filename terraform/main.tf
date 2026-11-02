locals {
  container_url       = "abfss://${var.storage_container_name}@${var.storage_account_name}.dfs.core.windows.net/"
  catalog_storage_url = "${local.container_url}catalogs/${var.catalog_name}"
}

module "storage_credential" {
  source = "./modules/storage_credential"

  name                = var.storage_credential_name
  access_connector_id = var.access_connector_id
  platform_principal  = "sp-olist-databricks-platform"
}

module "external_location" {
  source = "./modules/external_location"

  name                  = var.external_location_name
  url                   = local.container_url
  credential_name       = module.storage_credential.name
  platform_principal    = "sp-olist-databricks-platform"
  etl_service_principal = var.etl_service_principal_name
}

module "catalog" {
  source = "./modules/catalog"

  name                  = var.catalog_name
  storage_root          = local.catalog_storage_url
  etl_service_principal = var.etl_service_principal_name

  depends_on = [module.external_location]
}

module "schemas" {
  source = "./modules/schemas"

  catalog_name          = module.catalog.name
  schema_names          = var.schema_names
  etl_service_principal = var.etl_service_principal_name
}
