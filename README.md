# Olist Databricks Platform Provisioning

Terraform project for Unity Catalog platform resources in the existing `dbx-olist-prod` workspace.

## Scope

- Create an Azure managed-identity-backed Unity Catalog storage credential using the existing Databricks Access Connector.
- Create an external location at the existing ADLS Gen2 `prod` container.
- Create the `olist_prod` catalog with a managed storage root under that container.
- Create `bronze`, `silver`, and `gold` schemas.
- Grant the ETL service principal catalog/schema access.

This project does **not** create Azure resources, Databricks workspaces, service principals, the Access Connector, or the ADLS container. Those remain managed by the existing IaC project / identity setup.

## Prerequisites

1. Existing `dbx-olist-prod` workspace is assigned to the shared Unity Catalog metastore.
2. The platform service principal is assigned to the production workspace and can authenticate using the configured Azure DevOps WIF service connection.
3. The platform principal has metastore privileges already granted in the UI: `CREATE STORAGE CREDENTIAL`, `CREATE EXTERNAL LOCATION`, and `CREATE CATALOG`.
4. The Access Connector managed identity has `Storage Blob Data Contributor` on the ADLS Gen2 storage account.
5. The Azure DevOps platform service principal has `Storage Blob Data Contributor` on the Terraform state storage account/container (`saoliststate001` / `tfstate`) so the remote backend can read/write state. Its current subscription-level Reader role is not sufficient for state writes.
6. The platform service principal has `CREATE_EXTERNAL_LOCATION` on the storage credential. Terraform manages this grant after creating the credential; the creator/owner must have sufficient rights to grant it.
7. The platform principal has `CREATE_MANAGED_STORAGE` on the external location to create a catalog with a managed storage root.

## Repository layout

```text
.
├── azure-pipelines.yml
├── README.md
├── pipelines/
│   └── platform-deploy.yml
└── terraform/
    ├── backend.tf
    ├── main.tf
    ├── outputs.tf
    ├── providers.tf
    ├── variables.tf
    ├── terraform.tfvars.example
    └── modules/
        ├── storage_credential/
        ├── external_location/
        ├── catalog/
        └── schemas/
```

## Configure Azure DevOps

Create pipeline variables (or a variable group) with these names:

- `DATABRICKS_HOST`: production workspace URL, for example `https://adb-<workspace-id>.<number>.azuredatabricks.net`.
- `DATABRICKS_CLIENT_ID`: application/client ID of `sp-olist-databricks-platform`.
- `AZURE_TENANT_ID`: Entra tenant ID.
- `ADLS_STORAGE_ACCOUNT_NAME`: existing ADLS Gen2 storage account name.
- `DATABRICKS_ACCESS_CONNECTOR_ID`: full Azure resource ID of the existing Access Connector.
- `DATABRICKS_ETL_PRINCIPAL`: Databricks service-principal display name, expected to be `sp-olist-databricks-cicd`.

The pipeline uses the existing Azure Resource Manager service connection `Olist-Databricks-Platform-WIF` for Azure CLI WIF login. The Databricks Terraform provider uses that Azure CLI session. No client secret or PAT is used.

The pipeline uses the existing Terraform backend:

- Resource group: `rg-olist-iac-dev`
- Storage account: `saoliststate001`
- Container: `tfstate`
- State key: `olist-databricks-platform-prod.tfstate`

Change these backend values only if the actual backend differs.

## Configure the deployment environment

The Apply stage references the Azure DevOps environment `databricks-platform-prod`. Create this environment and configure an approval/check if you want an approval before production apply. If you use a different environment name, update `azure-pipelines.yml`.

## Run locally

Authenticate to Azure CLI as an identity that is authorized in the Databricks workspace, then:

```bash
cd terraform
cp terraform.tfvars.example terraform.tfvars
# Fill in the real values in terraform.tfvars
terraform init \
  -backend-config="resource_group_name=rg-olist-iac-dev" \
  -backend-config="storage_account_name=saoliststate001" \
  -backend-config="container_name=tfstate" \
  -backend-config="key=olist-databricks-platform-prod.tfstate" \
  -backend-config="use_azuread_auth=true"
terraform fmt -recursive
terraform validate
terraform plan
```

Do not commit `terraform.tfvars`, `.terraform/`, or state files.

## Important design notes

- The external location URL is the root of the existing `prod` container. The existing `bronze`, `silver`, and `gold` directories remain subdirectories; they are represented as Unity Catalog schemas, not separate containers.
- The catalog managed storage root is `catalogs/olist_prod` under the `prod` container. Confirm that this path is not already used by another catalog before applying.
- The Terraform `databricks_grant` resources are additive, resource-specific grants. Avoid replacing them with `databricks_grants` unless you intentionally want Terraform to manage the complete grant set on that securable.
- The shared metastore is used by dev and prod. The external location and catalog should be bound to the production workspace only if workspace binding is required by your isolation model. Workspace binding is not included in this first baseline and should be added after confirming the desired dev/prod visibility.
- This baseline deliberately does not modify metastore-level grants already created manually, avoiding accidental replacement of existing grants.
