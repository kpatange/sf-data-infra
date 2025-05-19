# Snowflake Sink Terraform Configuration
snowflake_account = "SANDBOX"
snowflake_organization = "VOLVOCARS"
snowflake_user = "SBX_CROSSPLANE_TEST_USR"
snowflake_role = "CLD-SNOWFLAKE-SANDBOX-SYSADMIN-SG"
snowflake_warehouse = "DEV_ADMIN_ANALYST_WHS"
snowflake_authenticator = "SNOWFLAKE_JWT"
#snowflake_password ="${env.snowflake_password}"


# Required environment-specific values

environment            = "SBX"
storage_account_name   = "edwsinksbx"
storage_container_name = "json"
database_name          = "DEV_ADMIN_DB"
schema_name            = "LOAD"
table_name             = "raw_orders_json"
file_format_type       = "JSON" # or JSON, PARQUET, etc.

# Control whether to create the pipe
pipe_create_flag       = true

# Optional COPY INTO clause variables
#on_error               = "CONTINUE"           # CONTINUE | SKIP_FILE | ABORT_STATEMENT
#size_limit             = null                 # Optional number (in bytes)
#purge                  = false                # true or false
#return_failed_only     = false                # true or false
#match_by_column_name   = "CASE_INSENSITIVE"   # CASE_SENSITIVE | CASE_INSENSITIVE | NONE
#include_metadata       = "file_name = METADATA$FILENAME"  # Example: column = METADATA$FIELD
#enforce_length         = false
#truncatecolumns        = false
#force                  = false
#load_uncertain_files   = false
#file_processor         = ""                   # Example: SCANNER = my_scanner SCANNER_OPTIONS = ('key'='value')
#load_mode              = "FULL_INGEST"        # FULL_INGEST | ADD_FILES_COPY
