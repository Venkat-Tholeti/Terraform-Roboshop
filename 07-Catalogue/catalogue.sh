#!/bin/bash

component=$1
dnf install ansible -y
ansible-pull -U https://github.com/daws-84s/ansible-roboshop-roles-tf.git -e component=$1 Main.yml