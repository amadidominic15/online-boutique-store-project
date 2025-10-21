# Online Boutique Microservices Deployment with Github Actions, Terraform, EKS, & ArgoCD

The goal of this project is to implement core DevOps principles, such as **Automation**, **CI/CD**, **Infrastructure as Code**, **Monitoring**, **DevSecOps**.  

This project demonstrates how to deploy the **Online Boutique** microservice application using a **poly-repo approach**(this is a mono-repo), leveraging **Github Actions CI/CD**, **Github Container Registry**, **Terraform**, **Helm**, **Argocd** and **Amazon EKS**. It demonstrates an end-to-end infrastructure and application automation workflow with CI/CD best practices, microservice modularity, and scalable cloud-native tools. 

## 📌 Project Overview

- **Source Code**: Cloned from the [GoogleCloudPlatform microservices-demo](https://github.com/GoogleCloudPlatform/microservices-demo).
- **Repositories/Folders**:
  - 11 repositories/Folders created (one for each microservice).
  - 1 repository/Folders for **Helm charts**.
  - 1 repository/Folders for **EKS infrastructure**.
  - 1 repository/Folders for **OIDC Terraform setup**.
  - 1 repository/Folders for **Argocd**.
  - 1 repository/Folders for **CI/CD pipelines**.

- **Workflow**:
  - Each microservice builds and pushes Docker images to the Github Container Registry.
  - The Helm repo `values.yaml` is updated with the new image URL and tag.
  - Deployments target **Amazon EKS** with Terraform-managed infrastructure.
  - **Authentication**: Github pipelines authenticate with AWS via **OIDC** (no static keys).
  - **Add-ons**: Ingress Nginx Controller, kube-prometheus-stack and Argocd installed with `eks-addons`.

## 🏗 Architecture

The architecture of the deployment is documented in the [`architecture`](https://github.com/seunayolu/online-boutique/tree/main/architecture) folder.  

### Architecture Diagram
![Online Boutique Architecture](https://github.com/seunayolu/online-boutique/blob/main/architecture/online-boutique-arch.png?raw=true)

Key components include:

- **Github Actions**: CI/CD pipelines, polyrepo management, triggers.
- **Terraform**: EKS cluster, VPC, OIDC, and add-ons.
- **Helm**: Chart templates for microservices deployment.
- **AWS EKS**: Managed Kubernetes cluster.
- **Ingress Nginx Controller**: Provides ELB integration for SSL termination and ingress.
- **Prometheus & Grafana**: Installed via kube-prometheus-stack for observability.
- **ArgoCD**: monitoring helm chart for image update and deployment
## 📂 Repository Structure

| Repository/Folder | Purpose |
|----------------------|---------|
| `oidc-setup` | Terraform code to configure Github OIDC authentication with AWS. |
| `eksinfra` | Terraform code for deploying EKS, VPC, and add-ons. |
| `helm` | Helm charts for all 11 microservices. |
| `argocd` | kubernetes manifest file to deploy app. |

## ⚙️ CI/CD Workflows

Each microservice project contains a `.github/workfows/microservice_name.yaml` pipeline with the following flow:

1. **Build & Push**  
   - Build Docker image.  
   - Push to GitHUB Container Registry.

2. **Update Helm Repo**    
   - Update `values.yaml` with new image URL and tag (`$CI_COMMIT_SHORT_SHA`).  
   - Commit and push changes.

```

## 🚀 Deployment Steps

1. **Setup OIDC for Github Actions → AWS**

   * Terraform configuration in [`oidc-setup`](https://github.com/seunayolu/online-boutique/tree/main/oidc-setup).
   * Removes the need for static IAM access keys.

2. **Deploy EKS Infrastructure**

   * Terraform code in [`eksinfra`](https://github.com/seunayolu/online-boutique/tree/main/eksinfra).
   * Uses:

     * `terraform-aws-eks` module
     * `terraform-aws-vpc` module
     * `eks-addons` for Ingress controller, ArgoCD & monitoring stack

3. **Deploy Microservices via ArgoCD**

   * Helm repo receives updated values from microservice pipelines.
   * ArgoCD picks up the update and deploys the application.

4. **Access Application**

   * Ingress managed via Ingress Nginx Controller.
   * SSL termination configured on the ALB.
   * Application exposed with secure HTTPS endpoints.

## 🎯 Learning Objectives

This project helps you learn:

1. How to implement **Github polyrepo/monorepo deployments**.
2. CI/CD repetable workflow for multiple build and push.
3. Leveraging **ArgoCD** for Kubernetes deployments in CI/CD.
4. Using **eks-addons** to install Kubernetes tools.
5. Configuring SSL access via ALB and Load Balancer Controller.


