#!/bin/bash

set -ex

sudo apt update

curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-4
chmod 700 get_helm.sh
./get_helm.sh

helm repo add traefik https://helm.traefik.io/traefik
helm repo update
helm install traefik traefik/traefik


