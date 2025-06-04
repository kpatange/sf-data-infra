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
variable "sf_account_nm" {
  type = string
  default= "SANDBOX"  # Change as needed
  description = "The Snowflake account name"
}


variable "environment" {
  type = string
  default= "dev"  # Change as needed
  description = "The environment for the Snowflake resources (e.g., dev, prod)"
}

variable "area_name" {
  type = string
  default = "sfarea"  # Change as needed
  description = "The area name for the Snowflake resources"
}

variable "owner_name" {
  type = string
  #default = "sfarea"  # Change as needed
  description = "The area name for the Snowflake resources"
}

resource "snowflake_database" "primary" {
  name = "${var.environment}_${var.area_name}_DB"
  comment = "Primary database for ${var.area_name} in ${var.environment} environment"
}

variable "schema_names" {
  type = list(string)
  description = "List of schema names to create in the Snowflake database"
  default = ["LOAD", "STG", "PSA","DM","TRF"]  # Example default, change as needed
}

resource "snowflake_schema" "primary" {
  for_each = toset(var.schema_names)
  database = snowflake_database.primary.name
  name     = each.value
  comment  = "Schema ${each.value} in ${snowflake_database.primary.name}"
}

# Add AD group
resource "snowflake_execute" "CREATE_AD_GROUP" {
  execute = "SELECT SBX_DINFRA_DB.LOAD.CREATE_AD_GROUP('CLD-SNOWFLAKE-${var.environment}-${var.area_name}-ANALYST-SG')"
  revert  = "SELECT 1"
}

resource "null_resource" "wait_signal" {
  provisioner "local-exec" {
    command = "sleep 30"
  }

  triggers = {
    always_run = "${timestamp()}"
  }
}

# Add owner to AD group
resource "snowflake_execute" "ADD_OWNER_TO_AD_GROUP" {

    depends_on = [
    snowflake_execute.CREATE_AD_GROUP,
    null_resource.wait_signal
  ]
  execute = "SELECT SBX_DINFRA_DB.LOAD.ADD_OWNER_TO_AD_GROUP('${var.owner_name}','CLD-SNOWFLAKE-${var.environment}-${var.area_name}-ANALYST-SG')"
  revert  = "SELECT 1"
}

#Add group members to SF
resource "snowflake_execute" "ADD_GROUP_TO_SNOWFLAKE" {
      depends_on = [
    snowflake_execute.CREATE_AD_GROUP,
    snowflake_execute.ADD_OWNER_TO_AD_GROUP,
    null_resource.wait_signal
  ]
  execute = "SELECT SBX_DINFRA_DB.LOAD.ADD_GROUP_TO_SNOWFLAKE('${var.sf_account_nm}','CLD-SNOWFLAKE-${var.environment}-${var.area_name}-ANALYST-SG')"
  revert  = "SELECT 1"
}

#Provision On Demand
resource "snowflake_execute" "PROVISION_ONDEMAND_TO_SNOWFLAKE" {

        depends_on = [
    snowflake_execute.CREATE_AD_GROUP,
    snowflake_execute.ADD_OWNER_TO_AD_GROUP,
    snowflake_execute.ADD_GROUP_TO_SNOWFLAKE,
    null_resource.wait_signal
  ]
  execute = "SELECT SBX_DINFRA_DB.LOAD.PROVISION_ONDEMAND_TO_SNOWFLAKE('${var.sf_account_nm}','CLD-SNOWFLAKE-${var.environment}-${var.area_name}-ANALYST-SG')"
  revert  = "SELECT 1"
}

##################################
### grants example
##################################

# grant and revoke privilege USAGE to ROLE on database
#resource "snowflake_execute" "test" {
#  execute = "GRANT USAGE ON DATABASE ABC TO ROLE XYZ"
#  revert  = "REVOKE USAGE ON DATABASE ABC FROM ROLE XYZ"
#}
#
## grant and revoke with for_each
#variable "database_grants" {
#  type = list(object({
#    database_name = string
#    role_id       = string
#    privileges    = list(string)
#  }))
#}
#
#resource "snowflake_execute" "test" {
#  for_each = { for index, db_grant in var.database_grants : index => db_grant }
#  execute  = "GRANT ${join(",", each.value.privileges)} ON DATABASE ${each.value.database_name} TO ROLE ${each.value.role_id}"
#  revert   = "REVOKE ${join(",", each.value.privileges)} ON DATABASE ${each.value.database_name} FROM ROLE ${each.value.role_id}"
#}