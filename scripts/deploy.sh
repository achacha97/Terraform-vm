#!/bin/bash
ENV=$1
cd terraform

terraform init
terraform plan -var-file="../tfvars/$ENV.tfvars"
terraform apply -var-file="../tfvars/$ENV.tfvars" -auto-approve
