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
variable "copy_on_error" {
  type    = string
  default = "CONTINUE"
}

variable "copy_size_limit" {
  type    = number
  default = null
}

variable "copy_purge" {
  type    = bool
  default = null
}

variable "copy_return_failed_only" {
  type    = bool
  default = null
}

variable "copy_match_by_column_name" {
  type    = string
  default = ""
}

variable "copy_include_metadata" {
  type    = string
  default = ""
}

variable "copy_enforce_length" {
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

variable "copy_load_uncertain_files" {
  type    = bool
  default = null
}

variable "copy_file_processor" {
  type    = string
  default = ""
}

variable "copy_load_mode" {
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

variable "file_format_record_delimiter" {
  type    = string
  default = null
}

variable "file_format_field_delimiter" {
  type    = string
  default = null
}

variable "file_format_file_extension" {
  type    = string
  default = null
}

variable "file_format_skip_header" {
  type    = number
  default = null
}

variable "file_format_skip_blank_lines" {
  type    = bool
  default = null
}

variable "file_format_date_format" {
  type    = string
  default = null
}

variable "file_format_time_format" {
  type    = string
  default = null
}

variable "file_format_timestamp_format" {
  type    = string
  default = null
}

variable "file_format_binary_format" {
  type    = string
  default = null
}

variable "file_format_escape" {
  type    = string
  default = null
}

variable "file_format_escape_unenclosed_field" {
  type    = string
  default = null
}

variable "file_format_null_if" {
  type    = list(string)
  default = null
}

variable "file_format_empty_field_as_null" {
  type    = bool
  default = null
}

variable "file_format_field_optionally_enclosed_by" {
  type    = string
  default = null
}

variable "file_format_trim_space" {
  type    = bool
  default = null
}

variable "file_format_error_on_column_count_mismatch" {
  type    = bool
  default = null
}

variable "file_format_replace_invalid_characters" {
  type    = bool
  default = null
}

variable "file_format_validate_utf8" {
  type    = bool
  default = null
}

variable "file_format_skip_byte_order_mark" {
  type    = bool
  default = null
}

variable "file_format_encoding" {
  type    = string
  default = null
}

variable "file_format_allow_duplicate" {
  type    = bool
  default = null
}

variable "file_format_strip_outer_array" {
  type    = bool
  default = null
}

variable "file_format_strip_null_values" {
  type    = bool
  default = null
}

variable "file_format_ignore_utf8_errors" {
  type    = bool
  default = null
}

variable "file_format_preserve_space" {
  type    = bool
  default = null
}

variable "file_format_column_names_in_first_line" {
  type    = bool
  default = null
}

variable "file_format_input_null_values" {
  type    = list(string)
  default = null
}

variable "file_format_output_null_values" {
  type    = list(string)
  default = null
}

variable "file_format_enable_octal" {
  type    = bool
  default = null
}

variable "file_format_disable_snowflake_identifier" {
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
  record_delimiter                 = var.file_format_record_delimiter
  field_delimiter                  = var.file_format_field_delimiter
  file_extension                   = var.file_format_file_extension
  skip_header                      = var.file_format_skip_header
  skip_blank_lines                 = var.file_format_skip_blank_lines
  date_format                      = var.file_format_date_format
  time_format                      = var.file_format_time_format
  timestamp_format                 = var.file_format_timestamp_format
  binary_format                    = var.file_format_binary_format
  escape                           = var.file_format_escape
  escape_unenclosed_field          = var.file_format_escape_unenclosed_field
  null_if                          = var.file_format_null_if
  empty_field_as_null              = var.file_format_empty_field_as_null
  field_optionally_enclosed_by    = var.file_format_field_optionally_enclosed_by
  trim_space                       = var.file_format_trim_space
  error_on_column_count_mismatch  = var.file_format_error_on_column_count_mismatch
  replace_invalid_characters      = var.file_format_replace_invalid_characters
  skip_byte_order_mark             = var.file_format_skip_byte_order_mark
  encoding                         = var.file_format_encoding
  allow_duplicate                  = var.file_format_allow_duplicate
  strip_outer_array                = var.file_format_strip_outer_array
  strip_null_values                = var.file_format_strip_null_values
  ignore_utf8_errors               = var.file_format_ignore_utf8_errors
  preserve_space                   = var.file_format_preserve_space
  enable_octal                     = var.file_format_enable_octal
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
    ${var.copy_on_error != "" ? "ON_ERROR = ${var.on_error}" : ""}
    ${var.copy_size_limit != null ? "SIZE_LIMIT = ${var.size_limit}" : ""}
    ${var.copy_purge != null ? "PURGE = ${var.purge}" : ""}
    ${var.copy_return_failed_only != null ? "RETURN_FAILED_ONLY = ${var.return_failed_only}" : ""}
    ${var.copy_match_by_column_name != "" ? "MATCH_BY_COLUMN_NAME = ${var.match_by_column_name}" : ""}
    ${var.copy_include_metadata != "" ? "INCLUDE_METADATA = (${var.include_metadata})" : ""}
    ${var.copy_enforce_length != null ? "ENFORCE_LENGTH = ${var.enforce_length}" : ""}
    ${var.copy_truncatecolumns != null ? "TRUNCATECOLUMNS = ${var.truncatecolumns}" : ""}
    ${var.copy_force != null ? "FORCE = ${var.force}" : ""}
    ${var.copy_load_uncertain_files != null ? "LOAD_UNCERTAIN_FILES = ${var.load_uncertain_files}" : ""}
    ${var.copy_file_processor != "" ? "FILE_PROCESSOR = (${var.file_processor})" : ""}
    ${var.copy_load_mode != "" ? "LOAD_MODE = ${var.load_mode}" : ""}
  EOT


}