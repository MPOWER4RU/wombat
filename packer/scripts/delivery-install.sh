#!/bin/bash -eux

echo '127.0.0.1 delivery-server.chef-automate.com delivery-server' | sudo tee -a /etc/hosts
sudo hostnamectl set-hostname delivery-server
sudo apt-get install jq
wget -q https://packages.chef.io/stable/ubuntu/12.04/chefdk_0.14.25-1_amd64.deb -O /tmp/chefdk_0.14.25-1_amd64.deb
sudo dpkg -i /tmp/chefdk_0.14.25-1_amd64.deb
wget -q https://chef.bintray.com/current-apt/ubuntu/14.04/delivery_0.4.317-1_amd64.deb -O /tmp/delivery_0.4.317-1_amd64.deb
sudo dpkg -i /tmp/delivery_0.4.317-1_amd64.deb
sudo mkdir -p /var/opt/delivery/license
sudo mkdir -p /etc/delivery
sudo chmod 0644 /etc/delivery
