# terraform_vpc

## What's here
This folder contains code for deploying a vpc with internet and nat gateways and public and private subnets.

It creates a public IP for use with a public instance in the public subnet.

The outputs.tf will generate ids used by other terraform folders via remote state.

## Notes
All directories assume the existence of a provider_override.tf file (look at .gitignore) that has your credentials.  State is assumed to be local but could easily be anywhere else (I recommend Terraform Cloud).

The VPC doesn't cost anything, but the nat gateway costs money on an hourly basis so feel free to create and destroy only when needed if you want to persist the VPC.  Easy way to destroy is 
```
terraform destroy -target YOURNATGATEWAY
```

or just move nat gateway to a separate deployment.
