variable "rancher_token_key" {}

provider "rancher2" {
  api_url   = "https://rancher-server"
  token_key = var.rancher_token_key
  insecure  = true
}

resource "rancher2_setting" "auth-user-info-max-age-seconds" {
  name  = "auth-user-info-max-age-seconds"
  value = "3600"
}
