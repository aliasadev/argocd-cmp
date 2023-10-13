#!/bin/bash +x

CONTEXT=$(kubectl config current-context)
if [[ $CONTEXT != *"minikube"* ]]; then echo -e "You are using $CONTEXT\nPlease switch to 'minikube' context";exit 1; fi

echo -e "\n[info] create namespaces"
kubectl create namespace argocd --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace kapp-controller --dry-run=client -o yaml | kubectl apply -f -

### ARGOCD
echo -e "\n[info] build the manifest"
helm repo add argo https://argoproj.github.io/argo-helm
helm repo update
# export GOMPLATE_LEFT_DELIM="<<"
# export GOMPLATE_RIGHT_DELIM=">>"
helm template argocd argo/argo-cd \
    --namespace=argocd \
    --create-namespace \
    --version=5.46.7 \
    --dependency-update \
    --include-crds \
    --values=$(dirname "$0")/values.yaml \
    >$(dirname "$0")/argocd-manifest.yaml

echo -e "\n[info] deploy argocd manifest"
kapp deploy \
    --app argocd \
    --namespace kapp-controller \
    --diff-changes \
    --apply-default-update-strategy=fallback-on-replace \
    --file $(dirname "$0")/argocd-manifest.yaml
