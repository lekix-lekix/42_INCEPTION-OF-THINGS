#!/bin/bash

sudo apt update
sudo DEBIAN_FRONTEND=noninteractive apt install -y iptables-persistent

# Get the master node's IP from the arguments
MASTER_IP=$1
MASTER_NAME=$2

sleep 15

while [ ! $TOKEN ]; do
    TOKEN=$(ssh -o StrictHostKeyChecking=no \
        -o UserKnownHostsFile=/dev/null \
        -i ./.ssh/shared_vm_key \
        vagrant@$MASTER_IP \
        "cat /home/vagrant/token 2>/dev/null")

    sleep 2
done

# Install K3s agent (worker) and join the master node
curl -sfL https://get.k3s.io | K3S_URL=https://$MASTER_IP:6443 K3S_TOKEN=$TOKEN sh -

echo "worker successfully initialized !"