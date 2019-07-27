variable "rancher_token_key" {}
variable "ldap_service_account_password" {}

provider "rancher2" {
  api_url   = "https://rancher-server"
  token_key = var.rancher_token_key
  insecure  = true
}

resource "rancher2_setting" "auth-user-info-max-age-seconds" {
  name  = "auth-user-info-max-age-seconds"
  value = "1800"
}

resource "rancher2_auth_config_openldap" "openldap" {
  enabled                            = true
  access_mode                        = "unrestricted"
  servers                            = ["openldap"]
  port                               = 389
  service_account_distinguished_name = "cn=admin,dc=example,dc=org"
  service_account_password           = var.ldap_service_account_password
  user_search_base                   = "ou=rancher,dc=example,dc=org"
  user_login_attribute               = "cn"
}
