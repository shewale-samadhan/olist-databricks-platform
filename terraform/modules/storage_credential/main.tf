resource "databricks_storage_credential" "this" {
  name = var.name

  azure_managed_identity {
    access_connector_id = var.access_connector_id
  }

  comment = "Production ADLS Gen2 credential managed by Terraform. Uses the existing Databricks Access Connector managed identity."
}

# The platform principal needs permission to create an external location
# that references this specific credential.
resource "databricks_grant" "platform_create_external_location" {
  storage_credential = databricks_storage_credential.this.id
  principal          = var.platform_principal
  privileges         = ["CREATE_EXTERNAL_LOCATION"]
}
