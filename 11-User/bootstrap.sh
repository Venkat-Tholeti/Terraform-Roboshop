#!/bin/bash

component=$1
dnf install ansible -y
ansible-pull -U https://github.com/Venkat-Tholeti/Ansible-Roles-Roboshop.git -e component=$1 - Main.yml
