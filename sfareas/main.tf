terraform {
  required_providers {
    snowflake = {
      source  = "Snowflake-Labs/snowflake"
    }
  }
  required_version = ">= 1.2"
}

variable "env_suffix" {
  description = "Environment suffix (e.g., SBX)"
  type        = string
  default     = "SBX"
}

variable "snowflake_area_name" {
  description = "Snowflake area name (e.g., DIFTEST6)"
  type        = string
  default     = "DIFTEST6"
}

variable "owners_cdsids" {
  description = "List of CDSIDs of area owners"
  type        = list(string)
  default     = ["SASHRAF", "KPATANGE"]
}

variable "snowflake_account_name" {
  description = "Snowflake account name (e.g., SANDBOX)"
  type        = string
  default     = "SANDBOX"
}


#################################
# Snowflake Execute: Area Setup
#################################
resource "snowflake_execute" "grants" {
  execute = <<EOT
    CALL LOAD_DEPLOYMENT_STATEMENTS(
      '${var.env_suffix}',
      '${var.snowflake_area_name}',
      '${jsonencode(var.owners_cdsids)}',
      '${var.snowflake_account_name}'
    );
  EOT

  revert     = "SELECT 1"
  depends_on = []
}

