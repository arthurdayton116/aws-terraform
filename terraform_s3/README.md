# terraform_s3

## What's here
This folder contains code for deploying a s3 bucket and the role and policy needed for ec2 instance to use it.

The outputs.tf will generate ids used by other terraform folders via remote state.

## Notes
All directories assume the existence of a provider_override.tf file (look at .gitignore) that has your credentials.  State is assumed to be local but could easily be anywhere else (I recommend Terraform Cloud).
