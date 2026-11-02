resource "databricks_schema" "this" {
  for_each = var.schema_names

  catalog_name = var.catalog_name
  name         = each.value
  comment      = "${title(each.value)} layer schema for the Olist production medallion architecture. Managed by Terraform."
}

resource "databricks_grant" "etl_schema_access" {
  for_each = databricks_schema.this

  schema     = each.value.id
  principal  = var.etl_service_principal
  privileges = ["USE_SCHEMA", "CREATE_TABLE", "MODIFY", "SELECT"]
}
