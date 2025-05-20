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
variable "copy_onError" {
  type    = string
  default = "CONTINUE"
}

variable "copy_sizeLimit" {
  type    = number
  default = null
}

variable "copy_purge" {
  type    = bool
  default = null
}

variable "copy_returnFailedOnly" {
  type    = bool
  default = null
}

variable "copy_matchByColumnName" {
  type    = string
  default = ""
}

variable "copy_includeMetadata" {
  type    = string
  default = ""
}

variable "copy_enforceLength" {
  type    = bool
  default = null
}

variable "copy_truncatecolumns" {
  type    = bool
  default = null
}

variable "copy_force" {
  type    = bool
  default = null
}

variable "copy_loadUncertainFiles" {
  type    = bool
  default = null
}

variable "copy_fileProcessor" {
  type    = string
  default = ""
}

variable "copy_loadMode" {
  type    = string
  default = ""
}

resource "snowflake_storage_integration" "integration" {
  name                      = "STI_${var.storage_account_name}_${var.storage_container_name}_${var.environment}"
  comment                   = "Storage Integration ${var.storage_account_name}"
  type                      = "EXTERNAL_STAGE"
  enabled                   = true
  storage_allowed_locations = [
    "azure://${var.storage_account_name}.blob.core.windows.net/${var.storage_container_name}"
  ]
  storage_provider          = "AZURE"
  azure_tenant_id           = "81fa766e-a349-4867-8bf4-ab35e250a08f"
}



# Optional Parameters
variable "file_format_compression" {
  type    = string
  default = null
}

variable "file_format_recordDelimiter" {
  type    = string
  default = null
}

variable "file_format_fieldDelimiter" {
  type    = string
  default = null
}

variable "file_format_fileExtension" {
  type    = string
  default = null
}

variable "file_format_skipHeader" {
  type    = number
  default = null
}

variable "file_format_skipBlankLines" {
  type    = bool
  default = null
}

variable "file_format_dateFormat" {
  type    = string
  default = null
}

variable "file_format_timeFormat" {
  type    = string
  default = null
}

variable "file_format_timestampFormat" {
  type    = string
  default = null
}

variable "file_format_binaryFormat" {
  type    = string
  default = null
}

variable "file_format_escape" {
  type    = string
  default = null
}

variable "file_format_escapeUnenclosedField" {
  type    = string
  default = null
}

variable "file_format_nullIf" {
  type    = list(string)
  default = null
}

variable "file_format_emptyFieldAsNull" {
  type    = bool
  default = null
}

variable "file_format_fieldOptionallyEnclosedBy" {
  type    = string
  default = null
}

variable "file_format_trimSpace" {
  type    = bool
  default = null
}

variable "file_format_errorOnColumnCountMismatch" {
  type    = bool
  default = null
}

variable "file_format_replaceInvalidCharacters" {
  type    = bool
  default = null
}

variable "file_format_validateUtf8" {
  type    = bool
  default = null
}

variable "file_format_skipByteOrderMark" {
  type    = bool
  default = null
}

variable "file_format_encoding" {
  type    = string
  default = null
}

variable "file_format_allowDuplicate" {
  type    = bool
  default = null
}

variable "file_format_stripOuterArray" {
  type    = bool
  default = null
}

variable "file_format_stripNullValues" {
  type    = bool
  default = null
}

variable "file_format_ignoreUtf8Errors" {
  type    = bool
  default = null
}

variable "file_format_preserveSpace" {
  type    = bool
  default = null
}

variable "file_format_columnNamesInFirstLine" {
  type    = bool
  default = null
}

variable "file_format_inputNullValues" {
  type    = list(string)
  default = null
}

variable "file_format_outputNullValues" {
  type    = list(string)
  default = null
}

variable "file_format_enableOctal" {
  type    = bool
  default = null
}

variable "file_format_disableSnowflakeIdentifier" {
  type    = bool
  default = null
}



resource "snowflake_file_format" "file_format" {
  name        = "FF_${var.storage_account_name}_${var.storage_container_name}_${var.environment}"
  database    = var.database_name
  schema      = var.schema_name
  format_type = var.file_format_type
  ## Optional parameters for the file format
  compression                      = var.file_format_compression
  record_delimiter                 = var.file_format_recordDelimiter
  field_delimiter                  = var.file_format_fieldDelimiter
  file_extension                   = var.file_format_fileExtension
  skip_header                      = var.file_format_skipHeader
  skip_blank_lines                 = var.file_format_skipBlankLines
  date_format                      = var.file_format_dateFormat
  time_format                      = var.file_format_timeFormat
  timestamp_format                 = var.file_format_timestampFormat
  binary_format                    = var.file_format_binaryFormat
  escape                           = var.file_format_escape
  escape_unenclosed_field          = var.file_format_escapeUnenclosedField
  null_if                          = var.file_format_nullIf
  empty_field_as_null              = var.file_format_emptyFieldAsNull
  field_optionally_enclosed_by    = var.file_format_fieldOptionallyEnclosedBy
  trim_space                       = var.file_format_trimSpace
  error_on_column_count_mismatch  = var.file_format_errorOnColumnCountMismatch
  replace_invalid_characters      = var.file_format_replaceInvalidCharacters
  skip_byte_order_mark             = var.file_format_skipByteOrderMark
  encoding                         = var.file_format_encoding
  allow_duplicate                  = var.file_format_allowDuplicate
  strip_outer_array                = var.file_format_stripOuterArray
  strip_null_values                = var.file_format_stripNullValues
  ignore_utf8_errors               = var.file_format_ignoreUtf8Errors
  preserve_space                   = var.file_format_preserveSpace
  enable_octal                     = var.file_format_enableOctal
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
    ${var.copy_onError != "" ? "ON_ERROR = ${var.copy_onError}" : ""}
    ${var.copy_sizeLimit != null ? "SIZE_LIMIT = ${var.copy_sizeLimit}" : ""}
    ${var.copy_purge != null ? "PURGE = ${var.copy_purge}" : ""}
    ${var.copy_returnFailedOnly != null ? "RETURN_FAILED_ONLY = ${var.copy_returnFailedOnly}" : ""}
    ${var.copy_matchByColumnName != "" ? "MATCH_BY_COLUMN_NAME = ${var.copy_matchByColumnName}" : ""}
    ${var.copy_includeMetadata != "" ? "INCLUDE_METADATA = (${var.copy_includeMetadata})" : ""}
    ${var.copy_enforceLength != null ? "ENFORCE_LENGTH = ${var.copy_enforceLength}" : ""}
    ${var.copy_truncatecolumns != null ? "TRUNCATECOLUMNS = ${var.copy_truncatecolumns}" : ""}
    ${var.copy_force != null ? "FORCE = ${var.copy_force}" : ""}
    ${var.copy_loadUncertainFiles != null ? "LOAD_UNCERTAIN_FILES = ${var.copy_loadUncertainFiles}" : ""}
    ${var.copy_fileProcessor != "" ? "FILE_PROCESSOR = (${var.copy_fileProcessor})" : ""}
    ${var.copy_loadMode != "" ? "LOAD_MODE = ${var.copy_loadMode}" : ""}
  EOT


}