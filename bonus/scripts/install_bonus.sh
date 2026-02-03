#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

sudo bash ./docker_install.sh

wget -q -O - https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash

sudo apt-get update

sudo apt-get install -y apt-transport-https ca-certificates curl gnupg pacman
sudo apt install -y build-essential curl git procps

# If the folder `/etc/apt/keyrings` does not exist, it should be created before the curl command, read the note below.
sudo mkdir -p -m 755 /etc/apt/keyrings
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.35/deb/Release.key | sudo gpg --dearmor --batch --yes -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
sudo chmod 644 /etc/apt/keyrings/kubernetes-apt-keyring.gpg # allow unprivileged APT programs to read this keyring

# This overwrites any existing configuration in /etc/apt/sources.list.d/kubernetes.list
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.35/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
sudo install -m 555 argocd-linux-amd64 /usr/local/bin/argocd
rm argocd-linux-amd64

sudo apt-get update

sudo apt-get install -y kubectl

curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-4
chmod 700 get_helm.sh
./get_helm.sh

k3d cluster create IOT -p "8080:80@loadbalancer"

mkdir -p ~/.kube
k3d kubeconfig get IOT > ~/.kube/config-
chmod 600 ~/.kube/config

kubectl create namespace argocd
kubectl create namespace dev
kubectl create namespace gitlab

helm repo add gitlab https://charts.gitlab.io/
helm repo update

helm upgrade --install gitlab gitlab/gitlab \
  --timeout 600s \
  --namespace gitlab \
  --set global.edition=ce \
  -f ../confs/gitlab_values.yaml

kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl wait --for=condition=Ready pods --all -n argocd --timeout=300s
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "ClusterIP"}}'
kubectl patch configmap argocd-cmd-params-cm -n argocd --type merge -p '{"data":{"server.insecure":"true"}}'
kubectl patch configmap argocd-cm -n argocd --type merge -p '{"data":{"timeout.reconciliation":"5s","repository.credentials.cache.expiration":"10s"}}'

kubectl apply -f ../confs/ingress_argocd.yaml
kubectl apply -f ../confs/ingress_app.yaml
kubectl apply -n argocd -f ../confs/argocd_config.yaml

kubectl rollout restart deployment argocd-server -n argocd
kubectl wait --for=condition=Ready pods -l app.kubernetes.io/name=argocd-server -n argocd --timeout=300s

while [ $(curl -s -o /dev/null -w "%{http_code}" "http://gitlab.gitlab.localhost:8080") -eq 404 ]; do
    sleep 1
done

echo "gitlab available!"
echo "gitlab password: $(kubectl get secret gitlab-gitlab-initial-root-password -n gitlab -o jsonpath='{.data.password}' | base64 -d)"
echo "argocd password: $(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)"
echo 'CLI login : argocd login argocd.localhost:8081 --insecure --grpc-web --username admin'

kubectl port-forward -n gitlab svc/gitlab-gitlab-shell 30022:30022
