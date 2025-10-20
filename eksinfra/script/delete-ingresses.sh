#!/bin/bash
set -e

# List of "namespace/ingress-name" pairs
INGRESSES=(
  "online-boutique/frontend"
  "argocd/argocd-server"
  "monitoring/grafana"
)

echo "Deleting all specified ingresses..."
for entry in "${INGRESSES[@]}"; do
  ns="${entry%%/*}"
  name="${entry##*/}"
  echo "- Deleting $name in $ns"
  kubectl delete ingress "$name" -n "$ns" --ignore-not-found
done

echo "Waiting for all ingresses to be deleted..."
for entry in "${INGRESSES[@]}"; do
  ns="${entry%%/*}"
  name="${entry##*/}"
  kubectl wait --for=delete ingress/"$name" -n "$ns" --timeout=120s || echo "Timeout waiting for $entry"
done

echo "Waiting 300 seconds for AWS NLB cleanup..."
sleep 300
