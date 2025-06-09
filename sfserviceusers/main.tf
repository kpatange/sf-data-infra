terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.0"
    }
    snowflake = {
      source  = "Snowflake-Labs/snowflake"
    } 
  }
  required_version = ">= 1.2"
}

variable "key_vault_access_entra_group" {
  type    = string
  default = "CLD-SNOWFLAKE-SANDBOX-SBX-EDW-ANALYST-SG"
}

variable "existing_azure_key_vault" {
  type    = bool
  default = false
}

variable "location" {
  type        = string
  description = "The Azure region where resources will be created."
  default     = "westeurope" 
}

variable "tags" {
  type        = map(string)
  description = "A map of tags to assign to the created resources."
  default     = {}
}

variable "vnet_name" {
  type        = string
  description = "The name of the existing Virtual Network."
  default     = "vnet-weu-app-3966-nonprod-001"
}

variable "vnet_rg_name" {
  type        = string
  description = "The name of the resource group where the existing Virtual Network is located."
  default     = "rg-network-nonprod-001"
}

variable "subnet_name" {
  type        = string
  description = "The name of the existing subnet within the Virtual Network where the private endpoint will be created."
  default     = "snet-weu-app-3966-nonprod-006"
}

variable "key_vault_name" {
  type        = string
  description = "The name for the Azure Key Vault."
}

variable "key_vault_rg_name" {
  type        = string
  description = "The name of the resource group where the Key Vault will be created or already exists."
  default     = "sf-demo-rg"
}

variable "key_vault_sku" {
  type        = string
  description = "The SKU name for the Key Vault (e.g., 'standard' or 'premium')."
  default     = "standard"
}

variable "key_passphrase" {
  type        = string
  description = "The passphrase for the RSA private key. If left empty, a random passphrase will be generated."
  default     = ""
  sensitive   = true
}

variable "service_user_name" {
  type        = string
  description = "The Snowflake username to associate with the generated RSA public key."
}

variable "comment" {
  type    = string
  default = "Snowflake Service User"
}

variable "environment" {
  type    = string
  default = "nonprod"
}

variable "snowflake_account_name" {
  type    = string
  default = "SANDBOX"
}

variable "application_id" {
  type    = string
  default = "app-3966"
}

variable "tools" {
  type    = string
  default = "ETL"
}

variable "private_key_name" {
  type    = string
  default = ""
}

variable "private_key_pkcs8_name" {
  type        = string
  description = "The name for the PKCS#8 formatted private key in Key Vault."
  default     = ""
}

variable "private_key_der_name" {
  type        = string
  description = "The name for the DER formatted private key in Key Vault."
  default     = ""
}

variable "snowflake_user_role" {
  type    = string
  default = "PUBLIC"
}

variable "passphrase_key_name" {
  type    = string
  default = ""
}

variable "private_endpoint_name" {
  type        = string
  description = "The name for the Key Vault private endpoint."
  default     = "kv"
}

variable "tfproviderSecret" {
  type        = string
  description = "The name for the Key Vault private endpoint."
  default     = "kv"
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy = true
    }
  }
}

#########################
# Data Sources
#########################
data "azurerm_client_config" "current" {}

data "azuread_group" "snowflake_access_group" {
  display_name = var.key_vault_access_entra_group
}

data "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  resource_group_name = var.vnet_rg_name
}

data "azurerm_subnet" "subnet" {
  name                 = var.subnet_name
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  resource_group_name  = var.vnet_rg_name
}

# Data source for existing Key Vault (when existing_azure_key_vault is true)
data "azurerm_key_vault" "existing" {
  count               = var.existing_azure_key_vault ? 1 : 0
  name                = var.key_vault_name
  resource_group_name = var.key_vault_rg_name
}

#########################
# Generate Passphrase
#########################
resource "random_password" "key_passphrase" {
  count            = var.key_passphrase == "" ? 1 : 0
  length           = 32
  special          = true
  override_special = "!@#$%^&*()-_=+[]{}<>:?"
}

locals {
  actual_passphrase = var.key_passphrase != "" ? var.key_passphrase : random_password.key_passphrase[0].result
  # Use existing or new Key Vault based on flag
  key_vault_id = var.existing_azure_key_vault ? data.azurerm_key_vault.existing[0].id : azurerm_key_vault.snowflake_keys[0].id
  key_vault_name = var.existing_azure_key_vault ? data.azurerm_key_vault.existing[0].name : azurerm_key_vault.snowflake_keys[0].name
  key_vault_uri = var.existing_azure_key_vault ? data.azurerm_key_vault.existing[0].vault_uri : azurerm_key_vault.snowflake_keys[0].vault_uri
  sv_user_name = replace(var.service_user_name, "_", "-")
}

#########################
# Key Vault Configuration
#########################
resource "azurerm_key_vault" "snowflake_keys" {
  count                         = var.existing_azure_key_vault ? 0 : 1
  name                          = var.key_vault_name
  location                      = var.location
  resource_group_name           = var.key_vault_rg_name
  tenant_id                     = data.azurerm_client_config.current.tenant_id
  sku_name                      = var.key_vault_sku
  soft_delete_retention_days    = 7
  purge_protection_enabled      = true
  enable_rbac_authorization     = false
  public_network_access_enabled = false
  tags                          = var.tags

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    secret_permissions = [
      "Get", "List", "Set", "Delete", "Recover", "Backup", "Restore", "Purge"
    ]
  }

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azuread_group.snowflake_access_group.object_id
    
    secret_permissions = [
      "Get", "List"
    ]
  }
}

#########################
# Private Endpoint (only for new Key Vault)
#########################
resource "azurerm_private_endpoint" "kv_private_endpoint" {
  count               = var.existing_azure_key_vault ? 0 : 1
  name                = "pe-${var.application_id}-${var.private_endpoint_name}-${var.environment}"
  location            = var.location
  resource_group_name = var.key_vault_rg_name
  subnet_id           = data.azurerm_subnet.subnet.id

  private_service_connection {
    name                           = "pc-${var.application_id}-${var.private_endpoint_name}-${var.environment}"
    private_connection_resource_id = azurerm_key_vault.snowflake_keys[0].id
    is_manual_connection           = false
    subresource_names              = ["vault"]
  }
}

#########################
# RSA Key Pair
#########################
resource "tls_private_key" "snowflake_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

#########################
# Store Original Private Key in Key Vault (PEM format)
#########################
resource "azurerm_key_vault_secret" "private_key" {
  name         = var.private_key_name
  value        = tls_private_key.snowflake_key.private_key_pem
  key_vault_id = local.key_vault_id

  depends_on = [
    azurerm_private_endpoint.kv_private_endpoint,
    azurerm_key_vault.snowflake_keys
  ]
}

#########################
# Convert PEM to PKCS#8 format using external data
#########################
data "external" "convert_to_pkcs8" {
  program = ["bash", "-c", <<-EOF
    echo '${tls_private_key.snowflake_key.private_key_pem}' | openssl pkcs8 -topk8 -inform PEM -outform PEM -nocrypt | jq -Rs '{"pkcs8": .}'
  EOF
  ]
}

#########################
# Convert PEM to DER format using external data
#########################
data "external" "convert_to_der" {
  program = ["bash", "-c", <<-EOF
    echo '${tls_private_key.snowflake_key.private_key_pem}' | openssl rsa -inform PEM -outform DER | base64 -w 0 | jq -Rs '{"der": .}'
  EOF
  ]
}

#########################
# Store PKCS#8 Private Key in Key Vault
#########################
resource "azurerm_key_vault_secret" "private_key_pkcs8" {
  name         = var.private_key_pkcs8_name
  value        = data.external.convert_to_pkcs8.result.pkcs8
  key_vault_id = local.key_vault_id

  depends_on = [
    azurerm_private_endpoint.kv_private_endpoint,
    azurerm_key_vault.snowflake_keys
  ]
}

#########################
# Store DER Private Key in Key Vault (Base64 encoded for storage)
#########################
resource "azurerm_key_vault_secret" "private_key_der" {
  name         = var.private_key_der_name
  value        = data.external.convert_to_der.result.der
  key_vault_id = local.key_vault_id

  depends_on = [
    azurerm_private_endpoint.kv_private_endpoint,
    azurerm_key_vault.snowflake_keys
  ]
}

#########################
# Store Passphrase in Key Vault (with user-specific name)
#########################
resource "azurerm_key_vault_secret" "passphrase" {
  name         = var.passphrase_key_name
  value        = local.actual_passphrase
  key_vault_id = local.key_vault_id

  depends_on = [
    azurerm_private_endpoint.kv_private_endpoint,
    azurerm_key_vault.snowflake_keys
  ]
}

#########################
# Snowflake User
#########################
resource "snowflake_user" "user" {
  name         = var.service_user_name
  comment      = var.comment
  disabled     = "false"
  default_role = var.snowflake_user_role

  rsa_public_key = replace(
    replace(
      tls_private_key.snowflake_key.public_key_pem,
      "-----BEGIN PUBLIC KEY-----", ""
    ),
    "-----END PUBLIC KEY-----", ""
  )
}

# create and destroy resource using qualified name
resource "snowflake_execute" "grants" {
  execute = "GRANT ROLE \"${var.snowflake_user_role}\" TO USER \"${var.service_user_name}\""
  revert = "SELECT 1"
}

# create and destroy resource using qualified name
resource "snowflake_execute" "sendmail" {
  execute = "CALL PROD_ADMIN_DB.UTILS.SEND_AREA_SERVICEUSR_EMAIL('${var.application_id}','${var.environment}','${var.snowflake_account_name}','${var.key_vault_name}','${var.application_id}','${var.service_user_name}')"
  revert = "SELECT 1"
}

#########################
# Create Kubernetes Secret for Crossplane
#########################
resource "kubernetes_secret" "snowflake_provider_credentials" {
  metadata {
    name      = var.tfproviderSecret
    namespace = "upbound-system"
  }

  data = {
    credentials = jsonencode({
      snowflake_account               = var.snowflake_account_name
      snowflake_organization          = "VOLVOCARS"
      snowflake_user                  = var.service_user_name
      snowflake_role                  = var.snowflake_user_role
      snowflake_warehouse             = "DEV_ADMIN_ANALYST_WHS"
      snowflake_authenticator         = "JWT"
      snowflake_private_key           = data.external.convert_to_pkcs8.result.pkcs8
      #snowflake_private_key_pkcs8     = data.external.convert_to_pkcs8.result.pkcs8
      #snowflake_private_key_der       = data.external.convert_to_der.result.der
      snowflake_private_key_passphrase = local.actual_passphrase
    })
  }

  type = "Opaque"
}

#########################
# Outputs
#########################
output "snowflake_user" {
  value = var.service_user_name
}

output "key_vault_name" {
  value = local.key_vault_name
}

output "key_vault_uri" {
  value = local.key_vault_uri
}

output "private_endpoint_id" {
  value = var.existing_azure_key_vault ? "N/A - Using existing Key Vault" : azurerm_private_endpoint.kv_private_endpoint[0].id
}

output "private_key_secret_name" {
  value = var.private_key_name
}

output "private_key_pkcs8_secret_name" {
  value = var.private_key_pkcs8_name
}

output "private_key_der_secret_name" {
  value = var.private_key_der_name
}

output "passphrase_secret_name" {
  value = var.passphrase_key_name
}