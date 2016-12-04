#!/bin/bash

sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 7BB9C367
sudo apt-get install -q -y --force-yes software-properties-common
sudo apt-add-repository -y "deb http://ppa.launchpad.net/ansible/ansible/ubuntu xenial main"
echo -e "\ndeb http://mirrors.digitalocean.com/debian jessie-backports main" | sudo tee -a /etc/apt/sources.list
sudo apt-get update -q
sudo apt-get install -y -q --force-yes ansible python-certbot-apache -t jessie-backports

sudo adduser --gecos "" --disabled-password vagrant
sudo chown vagrant:vagrant /home/vagrant -R
