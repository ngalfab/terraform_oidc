terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "5.1.0"
    }
  }
}

provider "azurerm" {
  # Configuration options
}

# Create a Service Principal associated with the App

resource "azuread_service_principal" "github_sp" {
  client_id                    = azuread_application.github_app.client_id
}                 

# Create Appilcetion Registration

resource "azuread_application" "github_app" {
  display_name = "github-actions-terraform"
}


# Create the Federated Credential (OIDC link to GitHub)

resource "azuread_application_federated_identity_credential" "github_fic" {
  application_id = azuread_application.github_app.id
  display_name   = "github-actions-main-branch"
  description    = "Allows GitHub Actions on main branch to authenticate"
  audiences      = ["api://AzureADTokenExchange"]
  issuer         = "https://token.actions.githubusercontent.com"
  subject        = "repo:ngalfab/terraform_oidc:environment:prod"
}