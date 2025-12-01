#!/bin/bash
set -e

# Install dependencies
sudo apt update -y
sudo apt install gnupg software-properties-common git -y
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update -y
sudo apt install terraform -y

# Create work directory
mkdir -p /opt/terraform
chmod 755 /opt/terraform
