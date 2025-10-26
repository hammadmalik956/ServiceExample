# 🏗️ Infrastructure Setup — Kubernetes (EKS) with Terraform & FluxCD


## Loom Video: https://www.loom.com/share/652587fefa764a1d86ca3027535c884a


This repository provisions and configures a complete **Kubernetes infrastructure** on AWS using **Terraform**, **FluxCD**, and **GitHub Actions**.  
It automatically sets up:
- **1 Master node**
- **2 Worker (slave) nodes**
- **FluxCD GitOps automation**
- **Helm deployments** for the `ServiceExample` application

---


## ⚙️ Prerequisites

Before running the pipeline, ensure the following tools and configurations are available:

### Local Environment
If you wish to deploy manually (optional):
- [Terraform ≥ 1.5](https://developer.hashicorp.com/terraform/downloads)
- [AWS CLI ≥ 2.0](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
- [kubectl](https://kubernetes.io/docs/tasks/tools/)
- [Helm](https://helm.sh/docs/intro/install/)

---

## 🔐 Required GitHub Secrets

Before running the **GitHub Actions pipeline**, configure the following repository secrets under  
`Settings → Secrets and variables → Actions`:

| Secret Name       | Description |
|-------------------|-------------|
| `AWS_OIDC_ROLE`   | ARN of the IAM role allowing GitHub OIDC access to AWS |
| `AWS_REGION`      | AWS region to deploy the infrastructure (e.g., `us-east-1`) |

> These are used by the GitHub Action to authenticate with AWS using OpenID Connect (OIDC) — no static credentials required.

---

## 🚀 Deployment via GitHub Actions

Once secrets are configured, **just trigger the pipeline from appropriate action**



