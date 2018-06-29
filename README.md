# terraform-automate-chef
repo that automates the process of building automate and  chef servers (standalone) and the supporting infrastructure and configuration.

What this builds:

VPC with six subnets, three private and three public
Security Group for chef and automate (you will need to lock it down)
chef server v 12 (amazon linux)
Automate server v 1 (amazon linux)
two runner servers (amazon linux)
installs and applys configuration for both servers via bash script loaded as userdata.


Assumptions:

1. terraform is installed on your workstation.

2. You have AWS Amazon account.

3. awscli and credentials are setup on your workstation.

4. You understand what terraform is building.

5. You know how to generate an ssh key.

6. you can read a bash script.



Directions:

1. Clone repo to your workstation
2. obtain license key for automate from chef.io
3. Create an s3 bucket in aws and upload you automate license to it.
4. Modify the role.tf to reflect name of new s3 bucket.
5. modify userdata in instances.tf to reflect new bucket name
6. generate ssh key called mykey or pick a name and modify terrafrom modules (vars.tf and key.tf) to reflect new name.
7. run "terraform init: in cloned repo directory
8. run "terraform apply" in cloned directory
9. lock down security group after everything is up, and add the Public IP addresses of your Chef and Automate servers to security group.

Troubleshooting":
  

1. troubleshoot if stuff goes wrong.
2. reference material: https://learn.chef.io/modules/manage-a-node-chef-automate/rhel/automate/set-up-your-chef-server#/

Note:
automate runs a preflight check , you can see the output file on the automate server in the tmp directory.
errors may need to be fixed if automate isnt working correctly.


If you are used to a management console for chef,  ssh into chef server
run:

#Install management console

sudo chef-server-ctl install chef-manage

sudo chef-server-ctl reconfigure

sudo chef-manage-ctl reconfigure

-------------------------------------------

Data collection:


Step 1: Configure a Data Collector token in Chef Automate¶

All messages sent to Chef Automate are performed over HTTP and are authenticated with a pre-shared key called a token. Every Chef Automate installation configures a token by default, but we strongly recommend that you create your own.

Note

The Data Collector token has no minimum or maximum character length restrictions. While the UTF-8 character set is supported, US-ASCII is recommended for best results.

To set your own token, add the following to your /etc/delivery/delivery.rb file:

    data_collector['token'] = 'sometokenvalue'
    # Save and close the file

To apply the changes, run:

    sudo automate-ctl reconfigure

If you do not configure a token, the default token value is: 93a49a4f2482c64126f7b6015e6b0f30284287ee4054ff8807fb63d9cbd1c506


Step 2: Configure your Chef server to point to Chef Automate¶

In addition to forwarding Chef run data to Automate, Chef server will send messages to Chef Automate whenever an action is taken on a Chef server object, such as when a cookbook is uploaded to the Chef server or when a user edits a role.



Setting up data collection on Chef server versions 12.14 and higher¶

Channel the token setting through the veil secrets library because the token is considered a secret, and cannot appear in /etc/opscode/chef-server.rb:

    sudo chef-server-ctl set-secret data_collector token 'TOKEN'
    sudo chef-server-ctl restart nginx
    sudo chef-server-ctl restart opscode-erchef

Then add the following setting to /etc/opscode/chef-server.rb on the Chef server:

    data_collector['root_url'] = 'https://my-automate-server.mycompany.com/data-collector/v0/'
    # Add for compliance scanning
    profiles['root_url'] = 'https://my-automate-server.mycompany.com'
    # Save and close the file

To apply the changes, run:

    chef-server-ctl reconfigure

where my-automate-server.mycompany.com is the fully-qualified domain name of your Chef Automate server.

