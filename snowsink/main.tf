terraform {
  required_providers {
    snowflake = {
      source = "Snowflake-Labs/snowflake"
    }
  }
}

# Variables for the Snowflake resources
variable "environment" {
  type = string
}

variable "storage_account_name" {
  type = string
}

variable "storage_container_name" {
  type = string
}

variable "database_name" {
  type = string
}

variable "schema_name" {
  type = string
}

variable "table_name" {
  type = string
}

variable "file_format_type" {
  type = string
}

variable "pipe_create_flag" {
  type = bool
}

# Optional COPY statement tuning variables
variable "on_error" {
  type    = string
  default = "CONTINUE"
}

variable "size_limit" {
  type    = number
  default = null
}

variable "purge" {
  type    = bool
  default = null
}

variable "return_failed_only" {
  type    = bool
  default = null
}

variable "match_by_column_name" {
  type    = string
  default = ""
}

variable "include_metadata" {
  type    = string
  default = ""
}

variable "enforce_length" {
  type    = bool
  default = null
}

variable "truncatecolumns" {
  type    = bool
  default = null
}

variable "force" {
  type    = bool
  default = null
}

variable "load_uncertain_files" {
  type    = bool
  default = null
}

variable "file_processor" {
  type    = string
  default = ""
}

variable "load_mode" {
  type    = string
  default = ""
}

resource "snowflake_storage_integration" "integration" {
  name                      = "STI_${var.storage_account_name}_${var.environment}"
  comment                   = "Storage Integration ${var.storage_account_name}"
  type                      = "EXTERNAL_STAGE"
  enabled                   = true
  storage_allowed_locations = [
    "azure://${var.storage_account_name}.blob.core.windows.net/${var.storage_container_name}"
  ]
  storage_provider          = "AZURE"
  azure_tenant_id           = "81fa766e-a349-4867-8bf4-ab35e250a08f"
}



resource "snowflake_file_format" "file_format" {
  name        = "FF_${var.storage_account_name}_${var.storage_container_name}_${var.environment}"
  database    = var.database_name
  schema      = var.schema_name
  format_type = var.file_format_type
}



resource "snowflake_stage" "stage" {
   depends_on = [
    snowflake_file_format.file_format
  ]
  name                = "EXT_${var.storage_account_name}_${var.storage_container_name}_${var.environment}"
  url                 = "azure://${var.storage_account_name}.blob.core.windows.net/${var.storage_container_name}"
  database            = var.database_name
  schema              = var.schema_name
  storage_integration = snowflake_storage_integration.integration.name
  comment             = "Stage for loading data"
}


resource "snowflake_pipe" "pipe" {
    depends_on = [
    snowflake_storage_integration.integration,
    snowflake_stage.stage,
    snowflake_file_format.file_format
  ]

  count       = var.pipe_create_flag ? 1 : 0
  name        = "PIPE_${var.storage_account_name}_${var.storage_container_name}_${var.environment}"
  database    = var.database_name
  schema      = var.schema_name
  comment     = "PIPE created by Crossplane"
  integration = "NOI_COMMONQUEUE_SBX"
  auto_ingest = true

  copy_statement = <<-EOT
    COPY INTO ${var.database_name}.${var.schema_name}.${var.table_name}
    FROM @${var.database_name}.${var.schema_name}."${snowflake_stage.stage.name}"
    FILE_FORMAT = (FORMAT_NAME = ${var.database_name}.${var.schema_name}."${snowflake_file_format.file_format.name}")
    ${var.on_error != "" ? "ON_ERROR = ${var.on_error}" : ""}
    ${var.size_limit != null ? "SIZE_LIMIT = ${var.size_limit}" : ""}
    ${var.purge != null ? "PURGE = ${var.purge}" : ""}
    ${var.return_failed_only != null ? "RETURN_FAILED_ONLY = ${var.return_failed_only}" : ""}
    ${var.match_by_column_name != "" ? "MATCH_BY_COLUMN_NAME = ${var.match_by_column_name}" : ""}
    ${var.include_metadata != "" ? "INCLUDE_METADATA = (${var.include_metadata})" : ""}
    ${var.enforce_length != null ? "ENFORCE_LENGTH = ${var.enforce_length}" : ""}
    ${var.truncatecolumns != null ? "TRUNCATECOLUMNS = ${var.truncatecolumns}" : ""}
    ${var.force != null ? "FORCE = ${var.force}" : ""}
    ${var.load_uncertain_files != null ? "LOAD_UNCERTAIN_FILES = ${var.load_uncertain_files}" : ""}
    ${var.file_processor != "" ? "FILE_PROCESSOR = (${var.file_processor})" : ""}
    ${var.load_mode != "" ? "LOAD_MODE = ${var.load_mode}" : ""}
  EOT


}