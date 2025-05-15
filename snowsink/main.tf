terraform {
  required_providers {
    snowflake = {
      source = "Snowflake-Labs/snowflake"
    }
  }
}

variable "environment" {
  type    = string
  default = "{{ .observed.composite.resource.spec.environment }}"
}

variable "storage_account_name" {
  type    = string
  default = "{{ .observed.composite.resource.spec.storageAccount.name }}"
}

variable "storage_container_name" {
  type    = string
  default = "{{ .observed.composite.resource.spec.storageAccount.containerName }}"
}

variable "database_name" {
  type    = string
  default = "{{ .observed.composite.resource.spec.database.name }}"
}

variable "schema_name" {
  type    = string
  default = "{{ .observed.composite.resource.spec.database.schemaName }}"
}

variable "table_name" {
  type    = string
  default = "{{ .observed.composite.resource.spec.database.tableName }}"
}

variable "file_format_type" {
  type    = string
  default = "{{ .observed.composite.resource.spec.snowPipe.fileFormat.type }}"
}

variable "pipe_create_flag" {
  type    = bool
  default = {{ .observed.composite.resource.spec.snowPipe.enabled }}
}

resource "snowflake_storage_integration" "integration" {
  name                     = "STI_${var.storage_account_name}_${var.environment}"
  comment                  = "Storage Integration ${var.storage_account_name}"
  type                     = "EXTERNAL_STAGE"
  enabled                  = true
  storage_allowed_locations = [
    "azure://${var.storage_account_name}.blob.core.windows.net/${var.storage_container_name}"
  ]
  storage_provider         = "AZURE"
  azure_tenant_id          = "81fa766e-a349-4867-8bf4-ab35e250a08f"
}

resource "snowflake_stage" "stage" {
  name                = "EXT_${var.storage_account_name}_${var.storage_container_name}_${var.environment}"
  url                 = "azure://${var.storage_account_name}.blob.core.windows.net/${var.storage_container_name}"
  database            = var.database_name
  schema              = var.schema_name
  storage_integration = snowflake_storage_integration.integration.name
  comment             = "Stage for loading data"
}

resource "snowflake_file_format" "file_format" {
  name        = "FF_${var.storage_account_name}_${var.storage_container_name}_${var.environment}"
  database    = var.database_name
  schema      = var.schema_name
  format_type = var.file_format_type
}

resource "snowflake_pipe" "pipe" {
  count           = var.pipe_create_flag ? 1 : 0
  name            = "PIPE_${var.storage_account_name}_${var.storage_container_name}_${var.environment}"
  database        = var.database_name
  schema          = var.schema_name
  comment         = "PIPE created by Crossplane"
  copy_statement  = "COPY INTO ${var.database_name}.${var.schema_name}.${var.table_name} FROM @${var.database_name}.${var.schema_name}.\"${snowflake_stage.stage.name}\""
  integration     = "NOI_COMMONQUEUE_SBX"
  auto_ingest     = true

  depends_on = [
    snowflake_storage_integration.integration,
    snowflake_stage.stage,
    snowflake_file_format.file_format
  ]
}
