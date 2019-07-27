# Running Rancher 2.2 with Terraform

(Proof of concept / experiment)

Make sure to update your Terraform state config in `terraform.tf`!

```sh
read -s TF_VAR_rancher_token_key
export TF_VAR_rancher_token_key
```

```sh
terraform init
terraform plan
terraform apply
```
