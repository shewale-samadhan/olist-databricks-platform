resource "databricks_catalog" "this" {
  name         = var.name
  storage_root = var.storage_root
  comment      = "Production catalog for the Olist medallion architecture. Managed by Terraform."
}

resource "databricks_grant" "etl_use_catalog" {
  catalog    = databricks_catalog.this.name
  principal  = var.etl_service_principal
  privileges = ["USE_CATALOG"]
}
