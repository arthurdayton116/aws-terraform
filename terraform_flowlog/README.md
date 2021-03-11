# terraform_flowlog

## What's here
This folder contains code for deploying a flowlog for a vpc.

It creates a role, policy and flow log, that monitors all traffic and sends logs to cloudwatch. for the vpc identified in data.tf.

## Notes
All directories assume the existence of a provider_override.tf file (look at .gitignore) that has your credentials.  State is assumed to be local but could easily be anywhere else (I recommend Terraform Cloud).
