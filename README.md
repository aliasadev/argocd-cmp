# ArgoCD Config Management Plugins

## Installation

```bash
kubectl create namespace argocd
```

This namespace will used for ArgoCD resources and your application will be deployed in its own namespace.

```bash
helm repo add argo https://argoproj.github.io/argo-helm
helm repo update
helm install argocd argo/argo-cd \
    --namespace=argocd \
    --create-namespace \
    --version=5.46.7 \
    --dependency-update \
    --values=argo-cd/values.yaml
```

## Usage

```bash
kubectl apply -f application.yaml
```
