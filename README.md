# provision-gke-cluster
## Switch to terraform workspace<br>

### Production:<br>
terraform workspace select production <br>
terraform init -backend-config=../backends/production.backend.tfvars<br>
terraform plan -var-file=vars/production.tfvars<br>
terraform apply -var-file=vars/production.tfvars<br>
<br>

### Staging:<br>
terraform workspace select staging<br>
terraform init -backend-config=../backends/staging.backend.tfvars<br>
terraform plan -var-file=vars/staging.tfvars<br>
terraform apply -var-file=vars/staging.tfvars
