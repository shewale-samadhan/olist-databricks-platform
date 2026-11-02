databricks_host       = "https://adb-7405611171151965.5.azuredatabricks.net"
databricks_client_id  = "5f582861-da9e-4c87-bb2c-ff96c7be2519"
azure_tenant_id       = "<microsoft-entra-tenant-id>"
storage_account_name  = "<existing-adls-gen2-storage-account-name>"
access_connector_id   = "/subscriptions/<subscription-id>/resourceGroups/rg-olist-prod/providers/Microsoft.Databricks/accessConnectors/<access-connector-name>"

storage_container_name      = "prod"
etl_service_principal_name  = "sp-olist-databricks-cicd"
storage_credential_name     = "olist-prod-storage-credential"
external_location_name      = "olist-prod-external-location"
catalog_name                = "olist_prod"
schema_names                = ["bronze", "silver", "gold"]
