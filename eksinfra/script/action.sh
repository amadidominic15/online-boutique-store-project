#!/bin/bash

# set action to apply or destroy
TERRAFORM_ACTION="destroy"

#Export to Github Actions 
echo "terraform_action=$TERRAFORM_ACTION" >> $GITHUB_OUTPUT

