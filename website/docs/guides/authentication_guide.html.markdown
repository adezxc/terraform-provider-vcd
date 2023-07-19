---
layout: "vcd"
page_title: "VMware Cloud Director: Authentication"
sidebar_current: "docs-vcd-guides-authentication"
description: |-
 Guide on authentication of the Terraform VCD Provider
---

# Authenticating the Terraform VCD Provider

This guide describes all the methods and their caveats of authenticating the 
Terraform VCD Provider.

Since Provider **v3.10.0** these are the supported methods of authentication 

|Method|[`auth_type`][auth_type]|Environment Variable|Example|
|------|------------------------|--------------------|-------|
|[User and password][userpassword]|`integrated`|`VCD_USER` `VCD_PASSWORD`|[Example](#connecting-using-username-and-password)|
|[SAML ADFS][saml]|`saml_adfs`|`VCD_SAML_ADFS_RPT_ID`|[Example](#connecting-with-saml)|
|[Token][token]|`token`|`VCD_TOKEN`|[Example](#connecting-with-token)|
|[API Token][api_token]|`api_token`|`VCD_USER` `VCD_PASSWORD`|[Example](#connecting-with-api-token)|
|[API Token file][api_token_file]|`api_token_file`|`VCD_USER` `VCD_PASSWORD`|[Example](#connecting-with-api-token-file)|
|[Service Account Token File][sa_token_file]|`service_account_token_file`|`VCD_USER` `VCD_PASSWORD`|[Example](#connecting-with-service-account-token-file)|

## Example usage

### Connecting using username and password

This is the most straightforward authentication method, 
you just use the credentials that are used to login to the VCD Web UI.

```terraform
# Configure the VMware Cloud Director Provider
provider "vcd" {
  user                 = var.vcd_user
  password             = var.vcd_pass
  auth_type            = "integrated"
  org                  = var.vcd_org
  vdc                  = var.vcd_vdc
  url                  = var.vcd_url
  max_retry_timeout    = var.vcd_max_retry_timeout
  allow_unverified_ssl = var.vcd_allow_unverified_ssl
}

# Create a new network in organization and VDC defined above
resource "vcd_network_routed" "net" {
  # ...
}
 ```

### Connecting with SAML

```terraform
# Configure the VMware Cloud Director Provider
provider "vcd" {
  auth_type            = "saml_adfs"
  saml_adfs_rpt_id     = var.saml_adfs_rpt_id
  org                  = var.vcd_org
  vdc                  = var.vcd_vdc
  url                  = var.vcd_url
  max_retry_timeout    = var.vcd_max_retry_timeout
  allow_unverified_ssl = var.vcd_allow_unverified_ssl
}

# Create a new network in organization and VDC defined above
resource "vcd_network_routed" "net" {
  # ...
}
 ```

### Connecting with token

```terraform
# Configure the VMware Cloud Director Provider
provider "vcd" {
  auth_type            = "token"
  token                = var.vcd_token
  org                  = var.vcd_org
  vdc                  = var.vcd_vdc
  url                  = var.vcd_url
  max_retry_timeout    = var.vcd_max_retry_timeout
  allow_unverified_ssl = var.vcd_allow_unverified_ssl
}

# Create a new network in organization and VDC defined above
resource "vcd_network_routed" "net" {
  # ...
}
 ```

### Connecting with API token

```terraform
# Configure the VMware Cloud Director Provider
provider "vcd" {
  auth_type            = "api_token"
  api_token            = var.vcd_api_token
  org                  = var.vcd_org
  vdc                  = var.vcd_vdc
  url                  = var.vcd_url
  max_retry_timeout    = var.vcd_max_retry_timeout
  allow_unverified_ssl = var.vcd_allow_unverified_ssl
}

# Create a new network in organization and VDC defined above
resource "vcd_network_routed" "net" {
  # ...
}
 ```

### Connecting with API token file

```terraform
# Configure the VMware Cloud Director Provider
provider "vcd" {
  auth_type            = "integrated"
  api_token_file       = "example_api_token.json"
  vdc                  = var.vcd_vdc
  url                  = var.vcd_url
  max_retry_timeout    = var.vcd_max_retry_timeout
  allow_unverified_ssl = var.vcd_allow_unverified_ssl
}

# Create a new network in organization and VDC defined above
resource "vcd_network_routed" "net" {
  # ...
}
 ```

### Connecting with Service Account token file

```terraform
# Configure the VMware Cloud Director Provider
provider "vcd" {
  auth_type                  = "service_account_token_file"
  service_account_token_file = "example_sa_token.json"
  org                        = var.vcd_org
  vdc                        = var.vcd_vdc
  url                        = var.vcd_url
  max_retry_timeout          = var.vcd_max_retry_timeout
  allow_unverified_ssl       = var.vcd_allow_unverified_ssl
}

# Create a new network in organization and VDC defined above
resource "vcd_network_routed" "net" {
  # ...
}
 ```

You can create a service account using the [`vcd_service_account`][service_account_resource] service_account_resource
  or if you don't want to manage it using Terraform, through a [script][service_account_script] residing in the provider repository.

~> **NOTE** If using `service_account_token_file` or `api_token_file`, the files
  need to be in JSON format,  

[auth_type]: /providers/vmware/vcd/latest/docs#auth_type
[userpassword]: /providers/vmware/vcd/latest/docs#user
[saml]: /providers/vmware/vcd/latest/docs#saml_adfs_rpt_id
[token]: /providers/vmware/vcd/latest/docs#token
[api_token]: /providers/vmware/vcd/latest/docs#api_token
[api_token_file]: /providers/vmware/vcd/latest/docs#api_token_file
[sa_token_file]: /providers/vmware/vcd/latest/docs#service_account_token_file
[service_account_resource]: /providers/vmware/vcd/latest/docs/resources/service_account
[service_account_script]: https://github.com/vmware/terraform-provider-vcd/blob/main/scripts/create_service_account.sh

