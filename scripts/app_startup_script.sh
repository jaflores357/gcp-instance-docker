#!/bin/bash -xe

#echo "deb https://rundeck.bintray.com/rundeck-deb /" | sudo tee -a /etc/apt/sources.list.d/rundeck.list
#curl 'https://bintray.com/user/downloadSubjectPublicKey?username=bintray' | sudo apt-key add -
#sudo apt-get update
#sudo apt-get install rundeck -y
#sudo apt install openjdk-8-jdk-headless -y

sudo apt-get update

sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common -y

curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -

sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable"

sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io -y
sudo curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

sudo systemctl start docker
sudo mkdir -p /opt/rundeck/mysql

sudo bash -c "cat<<EOF > /opt/rundeck/docker-compose.yml
version: '3'

services:
    # rundeck:
    #     image: rundeck/rundeck:3.3.4
    #     links:
    #       - mysql
    #     environment:
    #         RUNDECK_DATABASE_DRIVER: org.mariadb.jdbc.Driver
    #         RUNDECK_DATABASE_USERNAME: rundeck
    #         RUNDECK_DATABASE_PASSWORD: rundeck
    #         RUNDECK_DATABASE_URL: jdbc:mysql://mysql/rundeck?autoReconnect=true&useSSL=false
    #     ports:
    #       - 4440:4440
    mysql:
        image: mysql:5.7
        expose:
          - 3306
        environment:
          - MYSQL_ROOT_PASSWORD=root
          - MYSQL_DATABASE=rundeck
          - MYSQL_USER=rundeck
          - MYSQL_PASSWORD=rundeck
        ports:
          - 3306:3306
        volumes:
          - /opt/rundeck/mysql:/var/lib/mysql

EOF"

# terraform 

curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install terraform

# Ansible

sudo apt update
sudo apt install dirmngr --install-recommends

echo "deb http://ppa.launchpad.net/ansible/ansible/ubuntu trusty main" >> /etc/apt/sources.list
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 93C4A3FD7BB9C367
sudo apt update
sudo apt install ansible -y

# Git clone plugin

https://github.com/rundeck-plugins/git-plugin/releases/download/1.0.4/git-plugin-1.0.4.jar

