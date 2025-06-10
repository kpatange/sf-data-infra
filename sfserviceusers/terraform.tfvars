# Snowflake Sink Terraform Configuration
snowflake_account = "SANDBOX"
snowflake_organization = "VOLVOCARS"
snowflake_user = "SBX_CROSSPLANE_TEST_USR"
snowflake_role = "CLD-SNOWFLAKE-SANDBOX-SYSADMIN-SG"
snowflake_warehouse = "DEV_ADMIN_ANALYST_WHS"
snowflake_authenticator = "SNOWFLAKE_JWT"
#snowflake_password ="${env.snowflake_password}"
#snowflake_role = "CLD-SNOWFLAKE-SANDBOX-SYSADMIN-SG"


#
#snowflake_account_name = "SANDBOX"
#environment = "nonprod"
#application_id = "3966"
#service_user_name = "DEV_DINFRA_USER3"
#snowflake_user_role = "PUBLIC"
#comment = "Snowflake user for Crossplane integration testing"
##tools = "Terraform, Crossplane"
##Azure keyvault
#key_vault_name= "sf-3966-kv-nonprod"      ###3-24 alpahnumeric characters with only - allowed
#private_key_name="dev-dinfra-user3-pk"    ###3-24 alpahnumeric characters with only - allowed
#passphrase_key_name="dev-dinfra-user3-pp" ###3-24 alpahnumeric characters with only - allowed
#existing_azure_key_vault = true           ### Set to true if the Key Vault already exists in our managed resource group
#key_vault_access_entra_group = "cld-snowflake-sandbox-sysadmin-sg" ### Name of the Azure AD group that will have access to the Key Vault


# Basic configuration
#create_snowflake_user = "DEV_DINFRA_USER"
#kv_access_role_name   = "cld-snowflake-sandbox-sysadmin-sg"
#key_vault_name      = "sf-demo9-kv-001"
#key_vault_rg_name   = "sf-demo-rg"
#vnet_rg_name        = "rg-network-nonprod-001"
#location            = "westeurope"

# Key Vault settings
#key_vault_sku = "standard"
#tags = {
#  Environment = "Production"
#  Project     = "Snowflake"
#  Owner       = "DataTeam"
#}

# Network configuration
#vnet_name           = "vnet-weu-app-3966-nonprod-001"
#subnet_name         = "snet-weu-app-3966-nonprod-006"
#private_endpoint_name = "sf-demo9-kv-private-endpoint"

# Optional - if you want to set a specific passphrase
# key_passphrase = "your-strong-passphrase-here"