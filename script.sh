#!/bin/bash

lsb_release -a
# sudo apt-get update -y && sudo apt-get upgrade -y
sudo apt-get install wget -y
sudo apt-get install unzip -y 
### creating required directories
sudo mkdir -p /opt/software
sudo mkdir -p /opt/software/sonar
sudo mkdir -p /opt/software/maven
sudo mkdir -p /opt/software/jenkins
sudo groupadd -g 7001 oinstall
sudo chown -R ubuntu:oinstall /opt/software
sudo chmod 775 /opt/software
### creating required users
sudo groupadd -g 5001 jenkins
sudo useradd -m -d /home/jenkins -s /bin/bash jenkins -u 5001 -g 5001 -G oinstall,jenkins
sudo usermod -aG oinstall,jenkins jenkins 
sudo groups jenkins

sudo groupadd -g 5002 docker
sudo useradd -m -d /home/docker -s /bin/bash docker -u 5002 -g 5002
sudo usermod -aG oinstall,docker docker 
sudo groups docker

sudo groupadd -g 5003 sonar
sudo useradd -m -d /home/sonar -s /bin/bash sonar -u 5003 -g 5003
sudo usermod -aG oinstall,sonar sonar 
sudo groups sonar

sudo usermod -aG docker,oinstall ubuntu

echo "jenkins password sudo"
sudo sh -c "echo \"jenkins ALL=(ALL) NOPASSWD: ALL\" >> /etc/sudoers"
sudo sh -c "echo \"docker ALL=(ALL) NOPASSWD: ALL\" >> /etc/sudoers"
sudo sh -c "echo \"sonar ALL=(ALL) NOPASSWD: ALL\" >> /etc/sudoers"

### install reqired packages
echo "installing java"
sudo apt install default-jdk -y

echo "installing git"
sudo apt install git

echo "installing docker"
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove $pkg; done
# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

echo "installing maven"
sudo apt-get install maven -y

mvn -version

echo "installing jenkins"
sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update
sudo apt-get install jenkins -y

date=$(date '+%Y-%m-%d-%H:%M:%S')
sudo echo "Jenkins install date ${date}" >> /opt/software/jenkins/jenkins_password.txt
sudo cat /var/lib/jenkins/secrets/initialAdminPassword >> /opt/software/jenkins/jenkins_password.txt

echo "installing helm"
cd /opt/software
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh