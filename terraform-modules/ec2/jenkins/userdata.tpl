#!/bin/bash
yum -y remove java-17-amazon-corretto-headless java-17-amazon-corretto 
yum update –y
wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
amazon-linux-extras install java-openjdk11 -y
yum install jenkins -y
systemctl enable jenkins --now
sudo mkdir /var/lib/jenkins/.ssh/ ; ssh-keyscan -H $(hostname  -I) >> /var/lib/jenkins/.ssh/known_hosts ; chown -R jenkins. /var/lib/jenkins/.ssh/

amazon-linux-extras install -y docker
systemctl enable docker --now

amazon-linux-extras -y nginx
systemctl enable nginx --now

curl -o kubectl https://s3.us-west-2.amazonaws.com/amazon-eks/1.22.6/2022-03-09/bin/linux/amd64/kubectl
chmod +x kubectl ; mv kubectl /usr/bin/

curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh -s -- -b $HOME v0.22.0 ; sudo mv trivy /usr/bin/
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
cp /usr/local/bin/helm /usr/bin/