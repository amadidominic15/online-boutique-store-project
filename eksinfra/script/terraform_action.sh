#!/bin/bash
set -e

# Terraform action passed as argument (apply or destroy)
ACTION=$1

echo "Terraform action is: $ACTION"

echo "Initializing Terraform..."
terraform init -input=false

echo "Running Terraform Plan..."
terraform plan -input=false -out=tfplan

if [ "$ACTION" = "apply" ]; then
  echo "Creating Infrastructure..."
  terraform apply -input=false --auto-approve tfplan
elif [ "$ACTION" = "destroy" ]; then
  echo "Destroying Infrastructure..."
  terraform destroy --auto-approve
else
  echo "❌ Unknown terraform action: $ACTION"
  exit 1
fi
