# terraform_common

## What's here
This folder contains code for deploying commonly used resources such as tags to create reduce redundant code in other deployments.

The outputs.tf will generate objects used by other terraform folders via remote state.

## Notes
There is no provider in this deployment because it only generates static outputs.
