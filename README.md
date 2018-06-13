# terraform-automate
repo that automates the process of building automate and  chef servers (standalone) and the supporting infrastructure and configuration.

What this builds
VPC with six subnets, three private and three public
Security Group for chef and automate (you will need to lock it down)
chef server v 12
Automate server v 1
two runner servers
applys configuration for both servers via bash script loaded as userdata.


Assumptions:

1. terraform is installed on your workstation.

2. You have AWS Amazon account.

3. awscli and credentials are setup on your workstation.

4. You understand what terraform is building.

5. You know how to generate an ssh key.

6.  you can read a bash script.

Directions:

Clone repo to your workstation
Create an s3 bucket in aws 
Modify the role.tf to reflect name of new s3 bucket.
generate ssh key called mykey or pick a name and modify terrafrom modules to reflect new name.
run "terraform init: in cloned repo directory
run "terraform apply" in cloned directory
