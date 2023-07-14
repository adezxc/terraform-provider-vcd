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
|------|-----------|--------------------|-------|
|[User and password][userpassword]|`integrated`|`VCD_USER` `VCD_PASSWORD`|[Example][#connecting-as]|
|[SAML ADFS][saml]|`saml_adfs`|`VCD_SAML_ADFS_RPT_ID`|[Example][saml_example]|
|[Token][token]|`token`|`VCD_TOKEN`|[Example][token_example]|
|[API Token][api_token]|`api_token`|`VCD_USER` `VCD_PASSWORD`|[Example][api_token_example]|
|[API Token file][api_token_file]|`api_token_file`|`VCD_USER` `VCD_PASSWORD`|[Example][api_token_file_example]|
|[Service Account Token File][sa_token_file]|`service_account_token_file`|`VCD_USER` `VCD_PASSWORD`|[Example][sa_token_file_example]|

## Example usage

[integrated_example]
### Connecting using user and password

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

### Connecting with


[auth_type]: /providers/vmware/vcd/latest/docs#auth_type
[userpassword]: /providers/vmware/vcd/latest/docs#user
[saml]: /providers/vmware/vcd/latest/docs#saml_adfs_rpt_id
[token]: /providers/vmware/vcd/latest/docs#token
[api_token]: /providers/vmware/vcd/latest/docs#api_token
[api_token_file]: /providers/vmware/vcd/latest/docs#api_token_file
[sa_token_file]: /providers/vmware/vcd/latest/docs#service_account_token_file










