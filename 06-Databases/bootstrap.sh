#!/bin/bash

dnf install ansible -y
ansible-pull -U https://github.com/Venkat-Tholeti/Ansible-Roles-Roboshop.git -e component=$1 -e env=$2 Main.yml
