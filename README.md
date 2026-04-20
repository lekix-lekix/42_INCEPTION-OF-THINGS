# 🧠 Inception of Things
 
A deep dive into **Kubernetes** and **DevOps automation** through a series of progressive, containerized environments powered by **K3s**, **K3d**, **Argo CD**, and **GitOps** principles.
 
---
 
## 📦 Overview
 
**Inception of Things** (IoT) is a 42-school project designed to familiarize students with Kubernetes through hands-on infrastructure configuration. Each part builds upon the last, going deeper into the container rabbit hole.
 
| Part | Description | Technology |
|------|-------------|------------|
| **Part 1** | K3s cluster with master + agent nodes | `K3s` · `Vagrant` · `VirtualBox` |
| **Part 2** | K3s with multiple app deployments via Ingress | `K3s` · `Ingress` · `Deployments` |
| **Part 3** | K3d + Argo CD + GitOps pipeline | `K3d` · `Argo CD` · `GitOps` |
| **Bonus** | GitLab self-hosted + full CI/CD pipeline | `GitLab` · `Argo CD` · `K3d` |
 
---

## 📖 Key Concepts
 
<details>
<summary><strong>What is K3s?</strong></summary>
K3s is a lightweight, production-ready Kubernetes distribution by Rancher. It's packaged as a single binary and designed for resource-constrained environments like VMs, edge devices, or CI systems.
 
</details>
<details>
<summary><strong>What is K3d?</strong></summary>
K3d is a wrapper that runs K3s inside Docker containers enabling fast, local Kubernetes clusters with no VM overhead. Ideal for development and testing.
 
</details>
<details>
<summary><strong>What is Argo CD?</strong></summary>
Argo CD is a declarative GitOps continuous delivery tool for Kubernetes. It watches a Git repository and automatically applies changes to the cluster whenever the repo is updated.
 
</details>
<details>
<summary><strong>What is GitOps?</strong></summary>
GitOps is an operational model where Git is the **single source of truth** for infrastructure and application configuration. All changes go through Git, the cluster reconciles itself to match.
 
</details>

## 📝 License
 
This project is part of the **42 School** curriculum. All rights reserved to the respective authors.
