#!/bin/bash

set -ex

sudo apt update
sudo DEBIAN_FRONTEND=noninteractive apt install -y iptables-persistent

curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="server --write-kubeconfig-mode 644" sh -s -
echo "K3s server installation complete!"

curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-4
chmod 700 get_helm.sh
./get_helm.sh

kubectl apply -f ./deployment.yaml
kubectl apply -f ./service.yaml
kubectl apply -f ./ingress.yaml

export KUBECONFIG=/etc/rancher/k3s/k3s.yaml

helm repo add traefik https://helm.traefik.io/traefik
helm repo update
helm install traefik traefik/traefik
