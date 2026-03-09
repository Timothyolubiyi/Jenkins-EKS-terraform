#!/bin/bash
# installation of git on the EC2 instance
sudo apt update
sudo apt install git -y

# install Terraform on Ubuntu 22.04|20.04 |18.04

sudo apt-get update
sudo apt install  software-properties-common gnupg2 curl
#hwe-support-status --verbose
curl https://apt.releases.hashicorp.com/gpg | gpg --dearmor > hashicorp.gpg
sudo install -o root -g root -m 644 hashicorp.gpg /etc/apt/trusted.gpg.d/

sudo apt-add-repository "deb [arch=$(dpkg --print-architecture)] https://apt.releases.hashicorp.com $(lsb_release -cs) main"

sudo apt install terraform -y


### installation of helm
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3

 chmod 700 get_helm.sh

 ./get_helm.sh
 helm version



## install aws cli
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" 
sudo apt install unzip 
unzip awscliv2.zip 
sudo ./aws/install
#check the version
aws --version

## install kubectl cli

curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

kubectl version
kubectl version --client


# Create/update local kubeconfig for the cluster
aws eks update-kubeconfig --name eks-cluster-204 --region eu-north-1

#Verify context and cluster access
kubectl config current-context
kubectl get nodes
