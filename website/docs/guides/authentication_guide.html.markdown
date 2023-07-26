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
|[API Token][api_token]|`api_token`|`VCD_USER` `VCD_PASSWORD`|[Example](#connecting-with-api-token)|
|[API Token file][api_token_file]|`api_token_file`|`VCD_USER` `VCD_PASSWORD`|[Example](#connecting-with-api-token-file)|
|[Service Account Token File][sa_token_file]|`service_account_token_file`|`VCD_USER` `VCD_PASSWORD`|[Example](#connecting-with-service-account-token-file)|
|[SAML ADFS][saml]|`saml_adfs`|`VCD_SAML_ADFS_RPT_ID`|[Example](#connecting-with-saml)|
|[Token][token]|`token`|`VCD_TOKEN`|[Example](#connecting-with-bearerauthorization-token)|

## Example usage

### Connecting using username and password

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

With VCD 10.4.0+, similar to API token file, you can connect using a service account API token, as 
defined in the 
[documentation](https://blogs.vmware.com/cloudprovider/2022/07/cloud-director-service-accounts.html). 
Because a new API token is provided on every authentication request, 
the user is required to provide a readable+writable file in `json` 
format with the current API key. e.g:
```json
{"refresh_token":"xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"}
```
Note that the file will be rewritten at every usage, and the updated file will have additional fields, such as
```json
{
  "token_type": "Service Account",
  "refresh_token": "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
  "updated_by": "terraform-provider-vcd/v3.10.0 (darwin/arm64; isProvider:true)",
  "updated_on": "2023-04-18T14:33:07+02:00"
 }
```

The API token file is **sensitive data** and it's up to the user to secure it.

~> **NOTE:** The service account needs to be in `Active Stage` and 
it's up to the user to provide the initial API token. A service account 
can be created using the [`service_account`][service_account_resource] resource, 
also it can be done using a sample shell script for creating, authorizing 
and activating a VCD Service Account that can be found in the 
[repository][service_account_script]

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

### Connecting with SAML

```terraform
# Configure the VMware Cloud Director Provider
provider "vcd" {
  user                 = var.vcd_user
  auth_type            = "saml_adfs"
  # If `saml_adfs_rpt_id` is not specified - VCD SAML Entity ID will be used automatically
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

### Connecting with (bearer/authorization) token

This method is for authenticating using a bearer token 
(authorization token up to VCD version 10.4.0)
To get the bearer token, you can use the [script][bearer_token_script] residing
in our repository, simplifying the process.

~> **NOTE** This is not the same as [API token](#connecting-with-api-token) authorization, which
was introduced in VCD 10.3.1.


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


[auth_type]: /providers/vmware/vcd/latest/docs#auth_type
[userpassword]: /providers/vmware/vcd/latest/docs#user
[saml]: /providers/vmware/vcd/latest/docs#saml_adfs_rpt_id
[token]: /providers/vmware/vcd/latest/docs#token
[api_token]: /providers/vmware/vcd/latest/docs#api_token
[api_token_file]: /providers/vmware/vcd/latest/docs#api_token_file
[sa_token_file]: /providers/vmware/vcd/latest/docs#service_account_token_file
[service_account_resource]: /providers/vmware/vcd/latest/docs/resources/service_account
[service_account_script]: https://github.com/vmware/terraform-provider-vcd/blob/main/scripts/create_service_account.sh
[bearer_token_script]: https://github.com/vmware/terraform-provider-vcd/blob/main/scripts/get_token.sh


