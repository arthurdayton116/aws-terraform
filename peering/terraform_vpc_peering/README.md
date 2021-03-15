# terraform_vpc_peering

## What's here
This folder contains code for deploying n number of vpcs' with internet and nat gateways and public and private subnets. It demonstrates using local variables to create objects that can then be looped with for_each structures in resources and outputs.

It creates a public IPs for use with a public instance in the public subnet.

The outputs.tf will generate ids used by other terraform folders via remote state.

## Notes
All directories assume the existence of a provider_override.tf file (look at .gitignore) that has your credentials.  State is assumed to be local but could easily be anywhere else (I recommend Terraform Cloud).

The VPC doesn't cost anything, but the nat gateways costs money on an hourly basis. Creation of nat gateways is driven by nat_gateway property in subnet local var.
