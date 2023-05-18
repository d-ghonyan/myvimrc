#!/bin/bash

user="${1:-dghonyan}"

apt -y install sudo vim sl
sudo apt-get -y remove docker docker-engine docker.io containerd runc;
sudo apt-get -y update;
sudo apt-get -y install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release;
sudo mkdir -p /etc/apt/keyrings;
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg;
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo chmod a+r /etc/apt/keyrings/docker.gpg;
sudo apt-get -y  update;
sudo apt-get -y  install docker-ce docker-ce-cli containerd.io docker-compose-plugin;

#for u in $user
#do
sudo usermod -aG sudo $user;
sudo usermod -aG docker $user;
#done

sudo systemctl restart docker;
docker volume create wordpress
docker volume create mysql

#for u in $user
#do
su $user
cd $(HOME)
mkdir -p data/mysql data/wordpress \
	&& sudo ln -s /var/lib/docker/volumes/wordpress/_data/ data/wordpress \
	&& sudo ln -s /var/lib/docker/volumes/mysql/_data/ data/mysql
#done
