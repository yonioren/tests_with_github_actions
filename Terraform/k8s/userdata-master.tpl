#!/bin/bash

# Set hostname
sudo hostnamectl set-hostname ${hostname}

# ============================================
# PHASE 1: Prepare prerequisites and installations
# ============================================

# Update package list
add-apt-repository universe
sudo apt update

sudo apt install apt-transport-https ca-certificates curl gpg ansible -y

sudo mkdir -p /etc/ansible

cat <<EOF | sudo tee /etc/ansible/ansible.cfg
[defaults]
inventory = /etc/ansible/hosts
EOF

cat <<EOF | sudo tee -a /etc/hosts

### K8S hosts

$(hostname -i) ${hostname}
%{ for instance in workers ~}
${instance.ip} ${instance.name}
%{ endfor ~}
EOF

cat <<EOF | sudo tee /etc/ansible/hosts
[master]
${hostname}

[workers]
%{ for instance in workers ~}
${instance.name}
%{ endfor ~}

[all:vars] #Ignore ssh fingerprints
ansible_ssh_common_args='-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'
ansible_user=ubuntu
ansible_ssh_private_key_file=${private_key_location_on_server}
EOF

