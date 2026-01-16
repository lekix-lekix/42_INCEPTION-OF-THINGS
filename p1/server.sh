#!/bin/bash

sudo apt update
sudo DEBIAN_FRONTEND=noninteractive apt install -y iptables-persistent open-ssh

# Install K3s with specific options for VM environments
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="server --write-kubeconfig-mode 644" sh -s -

# Make sure kubectl is set up for the vagrant user
sudo mkdir -p /home/vagrant/.kube
sudo cp /etc/rancher/k3s/k3s.yaml /home/vagrant/.kube/config
sudo chown -R vagrant:vagrant /home/vagrant/.kube/config

# Get the token for the worker nodes
TOKEN=$(sudo cat /var/lib/rancher/k3s/server/node-token)
echo $TOKEN > /home/vagrant/token
chmod 644 /home/vagrant/token

echo "K3s server installation complete!"