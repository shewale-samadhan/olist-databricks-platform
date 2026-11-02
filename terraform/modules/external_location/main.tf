resource "databricks_external_location" "this" {
  name            = var.name
  url             = var.url
  credential_name = var.credential_name
  comment         = "Production ADLS Gen2 container external location managed by Terraform."
}

# The platform principal needs to place managed catalog data under this location.
resource "databricks_grant" "platform_create_managed_storage" {
  external_location = databricks_external_location.this.id
  principal         = var.platform_principal
  privileges        = ["CREATE_MANAGED_STORAGE"]
}

# Allow the ETL identity to read/write files through this location when its
# workloads need direct external-location file access.
resource "databricks_grant" "etl_file_access" {
  external_location = databricks_external_location.this.id
  principal         = var.etl_service_principal
  privileges        = ["READ_FILES", "WRITE_FILES"]
}
