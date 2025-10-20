#!/bin/bash
set -e

# Default to 'apply' if TF_ACTION is not set
TF_ACTION="${TF_ACTION:-apply}"

echo "Terraform action: $TF_ACTION"

# Prevent accidental destroy on push
if [[ "$GITHUB_EVENT_NAME" == "push" && "$TF_ACTION" == "destroy" ]]; then
  echo "Destroy action is not allowed on push events."
  exit 1
fi

# Initialize Terraform
terraform init

if [[ "$TF_ACTION" == "apply" ]]; then
  echo "Applying Terraform infrastructure..."
  terraform apply -auto-approve
elif [[ "$TF_ACTION" == "destroy" ]]; then
  echo "Destroying Terraform infrastructure..."
  terraform destroy -auto-approve
else
  echo "Unknown TF_ACTION: $TF_ACTION. Allowed values: apply, destroy"
  exit 1
fi
