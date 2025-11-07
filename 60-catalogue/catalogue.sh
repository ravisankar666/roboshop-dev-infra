#!/bin/bash

component=$1
environment=$2

dnf install ansible -y  # install ansible
# pull files form git and excute the playbook 
# ansible-pull -u https://github.com/ravisankar666/-ansible-roboshop-roles.tf.git -e component=$component main.yaml




REPO_URL = https://github.com/ravisankar666/-ansible-roboshop-roles.tf
REPO_DIR = opt/robohop/ansible
ANSIBLE_DIR = ansible-roboshop-roles.tf


mkdir -p $REPO_DIR         
mkdir -p /var/log/roboshop/
touch ansible.log

cd $REPO_DIR

#check if ansible repo is already cloned or not

if[ -d $ANSIBLE_DIR]; then
    cd $ANSIBLE_DIR
    git pull
else
    git clone $REPO_URL
    cd $ANSIBLE_DIR
fi 

echo "environment is : $2"

ansible-playbook -e component=$componenet -e env=$environment main.yaml