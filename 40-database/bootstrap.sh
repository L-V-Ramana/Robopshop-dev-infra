#!/bin/bash

dnf install ansible -y
ansible-pull -U https://github.com/L-V-Ramana/ansible-terraform.git -e component=$1 -e env=$2 main.yaml
# ansible-pull -U https://github.com/https://github.com/daws-84s/ansible-roboshop-roles.git -e component=$1 main.yaml
