#!/bin/bash

sudo dnf install ansible -y
ansible-pull -U "https://github.com/L-V-Ramana/ansible-terraform.git" -e component=$1 -e env=$2 main.yaml