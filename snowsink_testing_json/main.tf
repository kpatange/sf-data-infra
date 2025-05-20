#terraform {
# required_providers {
#   snowflake = {
#     source = "Snowflake-Labs/snowflake"
#   }
# }
#

############## CONFIGURATION FOR SNOWFLAKE PROVIDER ######################
terraform {
    #required_version = ">= 1.0.0"
    required_providers {  
      snowflake = {
        source  = "Snowflake-Labs/snowflake"
      } 
    }
    backend "azurerm" {
      resource_group_name  = "rg-weu-network-app-3966-nonprod"
      storage_account_name = "sfterraformstate"
      container_name       = "state"
      key                 = "snowflake.tfstate"
    }
  }

    variable "snowflake_account" {
      type = string
    }

    variable "snowflake_organization" {
      type = string
    }

    variable "snowflake_user" {
      type = string
    }


    variable "snowflake_role" {
      type = string
    }

    variable "snowflake_warehouse" {
      type = string
    }

    variable "snowflake_authenticator" {
      type = string
    }

    #variable "snowflake_private_key" {
    #  type = string
    #}

    #variable "snowflake_private_key_passphrase" {
    #  type = string
    #}

    variable "snowflake_password" {
        description = "Snowflake password"

    }


    provider "snowflake" {
      account_name  = var.snowflake_account
      organization_name = var.snowflake_organization
      user     = var.snowflake_user
      role     = var.snowflake_role
      warehouse = var.snowflake_warehouse
      #authenticator = "SNOWFLAKE_JWT"
      #private_key = var.snowflake_private_key
      #private_key_passphrase = var.snowflake_private_key_passphrase
      password=var.snowflake_password
      preview_features_enabled = ["snowflake_database_datasource","snowflake_storage_integration_resource","snowflake_stage_resource","snowflake_pipe_resource","snowflake_table_resource","snowflake_file_format_resource"]
    }


###############################################################################
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
variable "compression" {
  type    = string
  default = null
}

variable "record_delimiter" {
  type    = string
  default = null
}

variable "field_delimiter" {
  type    = string
  default = null
}

variable "file_extension" {
  type    = string
  default = null
}

variable "skip_header" {
  type    = number
  default = null
}

variable "skip_blank_lines" {
  type    = bool
  default = null
}

variable "date_format" {
  type    = string
  default = null
}

variable "time_format" {
  type    = string
  default = null
}

variable "timestamp_format" {
  type    = string
  default = null
}

variable "binary_format" {
  type    = string
  default = null
}

variable "escape" {
  type    = string
  default = null
}

variable "escape_unenclosed_field" {
  type    = string
  default = null
}

variable "null_if" {
  type    = list(string)
  default = null
}

variable "empty_field_as_null" {
  type    = bool
  default = null
}

variable "field_optionally_enclosed_by" {
  type    = string
  default = null
}

variable "trim_space" {
  type    = bool
  default = null
}

variable "error_on_column_count_mismatch" {
  type    = bool
  default = null
}

variable "replace_invalid_characters" {
  type    = bool
  default = null
}

variable "validate_utf8" {
  type    = bool
  default = null
}

variable "skip_byte_order_mark" {
  type    = bool
  default = null
}

variable "encoding" {
  type    = string
  default = null
}

variable "allow_duplicate" {
  type    = bool
  default = null
}

variable "strip_outer_array" {
  type    = bool
  default = null
}

variable "strip_null_values" {
  type    = bool
  default = null
}

variable "ignore_utf8_errors" {
  type    = bool
  default = null
}

variable "preserve_space" {
  type    = bool
  default = null
}

variable "column_names_in_first_line" {
  type    = bool
  default = null
}

variable "input_null_values" {
  type    = list(string)
  default = null
}

variable "output_null_values" {
  type    = list(string)
  default = null
}

variable "enable_octal" {
  type    = bool
  default = null
}

variable "disable_snowflake_identifier" {
  type    = bool
  default = null
}



resource "snowflake_file_format" "file_format" {
  name        = "FF_${var.storage_account_name}_${var.storage_container_name}_${var.environment}"
  database    = var.database_name
  schema      = var.schema_name
  format_type = var.file_format_type
  ## Optional parameters for the file format
  compression                      = var.compression
  record_delimiter                 = var.record_delimiter
  field_delimiter                  = var.field_delimiter
  file_extension                   = var.file_extension
  skip_header                      = var.skip_header
  skip_blank_lines                 = var.skip_blank_lines
  date_format                      = var.date_format
  time_format                      = var.time_format
  timestamp_format                 = var.timestamp_format
  binary_format                    = var.binary_format
  escape                           = var.escape
  escape_unenclosed_field          = var.escape_unenclosed_field
  null_if                          = var.null_if
  empty_field_as_null              = var.empty_field_as_null
  field_optionally_enclosed_by    = var.field_optionally_enclosed_by
  trim_space                       = var.trim_space
  error_on_column_count_mismatch  = var.error_on_column_count_mismatch
  replace_invalid_characters      = var.replace_invalid_characters
  skip_byte_order_mark             = var.skip_byte_order_mark
  encoding                         = var.encoding
  allow_duplicate                  = var.allow_duplicate
  strip_outer_array                = var.strip_outer_array
  strip_null_values                = var.strip_null_values
  ignore_utf8_errors               = var.ignore_utf8_errors
  preserve_space                   = var.preserve_space
  enable_octal                     = var.enable_octal
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
