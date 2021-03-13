# terraform_ec2_dynamic

# UNDER CONSTRUCTION

## What's here
This folder contains code for deploying a public and private ec2 instance.

Your local IP address is automatically added to network rules.

The existence of a VPC and S3 bucket are assumed and their remote state values are fetched in the data.tf file and placed in local variables.

The public server installs Minecraft and copies world files from an S3 bucket if they exist.  On shutdown, it will sync world files back to S3 bucket.

The outputs.tf will generate connection strings for ssh and http.

## Notes
All directories assume the existence of a provider_override.tf file (look at .gitignore) that has your credentials.  State is assumed to be local but could easily be anywhere else (I recommend Terraform Cloud).

- If you need to generate a key for ec2 instance locally (Mac)
  ```
  ssh-keygen -t rsa
  ```
