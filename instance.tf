resource "aws_instance" "chef-server" {
  ami           = "${lookup(var.AMIS, var.AWS_REGION)}"
  instance_type = "t2.2xlarge"
  root_block_device {
  volume_type = "gp2"
  volume_size = "100"
  delete_on_termination = "true"
}
  tags {
        Name = "chef-server"
        Department = "OPS"
    }

    iam_instance_profile = "${aws_iam_instance_profile.web_instance_profile.id}"
    user_data = <<HEREDOC
    #!/bin/bash
    sudo yum update
    sudo yum -y install curl
    echo $(curl -s http://169.254.169.254/latest/meta-data/local-hostname) | xargs sudo hostname
    

    # create staging directories
  if [ ! -d /drop ]; then
     mkdir /drop
  fi
  if [ ! -d /downloads ]; then
      mkdir /downloads
  fi

    # download the Chef server package
  if [ ! -f /downloads/chef-server-core-12.17.33-1.el7.x86_64.rpm ]; then
    echo "Downloading the Chef server package..."
    wget -nv -P /downloads https://packages.chef.io/files/stable/chef-server/12.17.33/el/7/chef-server-core-12.17.33-1.el7.x86_64.rpm
  fi

# install Chef server
  if [ ! $(which chef-server-ctl) ]; then
    echo "Installing Chef server..."
    rpm -Uvh /downloads/chef-server-core-12.17.33-1.el7.x86_64.rpm
    chef-server-ctl reconfigure

    echo "Waiting for services..."
    until (curl -D - http://localhost:8000/_status) | grep "200 OK"; do sleep 15s; done
    while (curl http://localhost:8000/_status) | grep "fail"; do sleep 15s; done

    echo "Creating initial user and organization..."
    chef-server-ctl user-create chefadmin Chef Admin admin@example.com Passw0rd --filename /drop/chefadmin.pem
    aws s3 cp /drop/chefadmin.pem  s3://bucketname/
    chef-server-ctl org-create ist "default" --association_user chefadmin --filename default.pem
    sleep 5
    chef-server-ctl install chef-manage
    chef-server-ctl reconfigure
    sudo ACCEPT_EULA=Yes chef-manage-ctl reconfigure

 fi

 echo "Your Chef server is ready!"
HEREDOC


 iam_instance_profile = "${aws_iam_instance_profile.web_instance_profile.id}"

  # the VPC subnet
  subnet_id = "${aws_subnet.main-public-1.id}"

  # the security group
  vpc_security_group_ids = ["${aws_security_group.automate.id}"]

  # the public SSH key
  key_name = "${aws_key_pair.mykeypair.key_name}"
}

resource "aws_instance" "automate-server" {
  ami           = "${lookup(var.AMIS, var.AWS_REGION)}"
  instance_type = "t2.2xlarge"
  root_block_device {
  volume_type = "gp2"
  volume_size = "100"
  delete_on_termination = "true"
}
  tags {
        Name = "automate-server"
        Department = "OPS"
    }

    iam_instance_profile = "${aws_iam_instance_profile.web_instance_profile.id}"
    user_data = <<HEREDOC
    #!/bin/bash
    sudo yum update
    sudo yum -y install curl
    echo $(curl -s http://169.254.169.254/latest/meta-data/local-hostname) | xargs sudo hostname
    

    chef_server_fqdn=$1

    # create downloads directory
    if [ ! -d /downloads ]; then
      mkdir /downloads
    fi

    # download the Chef Automate package
    if [ ! -f /downloads/automate-1.8.68-1.el7.x86_64.rpm ]; then
      echo "Downloading the Chef Automate package..."
      wget -nv -P /downloads https://packages.chef.io/files/stable/automate/1.8.68/el/7/automate-1.8.68-1.el7.x86_64.rpm
    fi

    # install Chef Automate
    if [ ! $(which automate-ctl) ]; then
      echo "Installing Chef Automate..."
      rpm -Uvh /downloads/automate-1.8.68-1.el7.x86_64.rpm

    # run preflight check
      automate-ctl preflight-check

    # run setup
      sleep 300
      aws s3 cp s3://bucketname/chefadmin.pem /tmp/
      aws s3 cp s3://bucketname/automate.license /tmp/
      automate-ctl setup --license /tmp/automate.license --key /tmp/chefadmin.pem --server-url https://$chef_server_fqdn/organizations/default --fqdn $(hostname) --enterprise default --configure --no-build-node
      automate-ctl reconfigure

    # wait for all services to come online
      echo "Waiting for services..."
      until (curl --insecure -D - https://localhost/api/_status) | grep "200 OK"; do sleep 1m && automate-ctl restart; done
      while (curl --insecure https://localhost/api/_status) | grep "fail"; do sleep 15s; done

    # create an initial user
      echo "Creating chefadmin user..."
      automate-ctl create-user default chefadmin --password Passw0rd --roles "admin"
    fi

echo "Your Chef Automate server is ready!"
HEREDOC

    # the VPC subnet
  subnet_id = "${aws_subnet.main-public-2.id}"

  # the security group
  vpc_security_group_ids = ["${aws_security_group.automate.id}"]

  # the public SSH key
  key_name = "${aws_key_pair.mykeypair.key_name}"
}


resource "aws_instance" "runner1" {
  ami           = "${lookup(var.AMIS, var.AWS_REGION)}"
  instance_type = "t2.micro"
  root_block_device {
  volume_type = "gp2"
  volume_size = "20"
  delete_on_termination = "true"
}
  tags {
        Name = "runner1"
        Department = "IST"
    }

    iam_instance_profile = "${aws_iam_instance_profile.web_instance_profile.id}"
    user_data = <<HEREDOC
    #!/bin/bash
    sudo yum update -y
    echo $(curl -s http://169.254.169.254/latest/meta-data/local-hostname) | xargs sudo hostname
HEREDOC

  # the VPC subnet
  subnet_id = "${aws_subnet.main-private-1.id}"

  # the security group
  vpc_security_group_ids = ["${aws_security_group.automate.id}"]

  # the public SSH key
  key_name = "${aws_key_pair.mykeypair.key_name}"
}


resource "aws_instance" "runner2" {
  ami           = "${lookup(var.AMIS, var.AWS_REGION)}"
  instance_type = "t2.micro"
  root_block_device {
  volume_type = "gp2"
  volume_size = "20"
  delete_on_termination = "true"

  
}
  tags {
        Name = "runner2"
        Department = "IST"
    }
    
    iam_instance_profile = "${aws_iam_instance_profile.web_instance_profile.id}"
    user_data = <<HEREDOC
    #!/bin/bash
    sudo yum update -y
    echo $(curl -s http://169.254.169.254/latest/meta-data/local-hostname) | xargs sudo hostname
HEREDOC
 
  # the VPC subnet
  subnet_id = "${aws_subnet.main-private-2.id}"

  # the security group
  vpc_security_group_ids = ["${aws_security_group.automate.id}"]

  # the public SSH key
  key_name = "${aws_key_pair.mykeypair.key_name}"
}
