## R81 Standalone Deployment with Terraform

This repo is an example of how to deploy a Standalone Manager/Gateway running R81 in AWS.

Terraform V.13.5 was used for this demo.

This example will create a new VPC, 3 subnets (External, Internal, DMZ) and setup the route 
tables for the subnets.  The DMZ subnet will send all traffic to the Internal interface of the 
Mgmt/Gateway.  NAT will need to be setup to allow traffic outbound or inbound.

The instance will be created with Application Control, URL Filtering, IPS, AV and Anti-Bot enabled.
The topology will be pulled from the instance automaticlly on the first boot when the API server
is up and available.

## Updates needed before deployment
```
# Update the terraform.tfvars to specify a valid AWS SSH key.
# If you would like to use another IP subnet as part of this example change the terraform.tfvars 
  network subnets as needed. (Note you will need to update the routes in the customdata.sh so the 
  gateway will have the proper routes on launch)
```

## Once the deployment is finished
```
1. SSH into the new instance and go to clish and change the admin password.   This is required to 
   login to SmartConsole.
2. Login to SmartConsole and modify/create a policy to apply to the gateway.  The demo deployment 
   does not create or apply/push a policy in this example script.
3. Push the policy to the gateway and verify the traffic is working as expected.
```
