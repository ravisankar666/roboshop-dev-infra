#!/bin/bash

dnf install ansible -y  # install ansible
# pull files form git and excute the playbook 
ansible-pull -u https://github.com/ravisankar666/-ansible-roboshop-roles.tf.git -e component=mongodb main.yaml
