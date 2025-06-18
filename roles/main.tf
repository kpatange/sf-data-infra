terraform {
  required_providers {
    snowflake = {
      source  = "Snowflake-Labs/snowflake"
    }
  }
  required_version = ">= 1.2"
}

variable "role_hierarchy" {
  type = string
}


#################################
# Snowflake Execute: Area Setup
#################################
resource "snowflake_execute" "grants" {
  
  #execute ="USE ROLE SYSADMIN;"
  execute = <<EOT
    CALL PROD_ADMIN_DB.UTILS.role_extension(
      '${var.role_hierarchy}'
    );
  EOT

  revert     = "SELECT 1"
  depends_on = []
}

