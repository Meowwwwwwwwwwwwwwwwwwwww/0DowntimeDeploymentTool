#!/bin/bash

set -e

APP_NAME="my-app"
VERSION=$1  # blue or green

if [[ "$VERSION" != "blue" && "$VERSION" != "green" ]]; then
  echo "Usage: ./deploy.sh [blue|green]"
  exit 1
fi

echo "[+] Building Docker image: saraswati332/$APP_NAME:$VERSION"
docker build -t saraswati332/$APP_NAME:$VERSION .

echo "[+] Pushing Docker image: saraswati332/$APP_NAME:$VERSION"
docker push saraswati332/$APP_NAME:$VERSION

echo "[+] Applying Kubernetes manifests for $APP_NAME ($VERSION)..."
kubectl apply -f k8s/app-$VERSION.yaml
kubectl apply -f k8s/service.yaml
kubectl apply -f k8s/ingress.yaml

echo "[+] Updating Ingress to point to $VERSION..."
if [ "$VERSION" == "green" ]; then
  kubectl annotate ingress my-app-ingress nginx.ingress.kubernetes.io/canary-weight="90" --overwrite
else
  kubectl annotate ingress my-app-ingress nginx.ingress.kubernetes.io/canary-weight="10" --overwrite
fi

echo "[✓] Deployed $APP_NAME ($VERSION) successfully."

# Optional: Health check & rollback
echo "[+] Waiting for rollout status..."
kubectl rollout status deployment/app-$VERSION || {
  echo "[✗] Rollout failed. Rolling back..."
  OTHER=$([[ "$VERSION" == "green" ]] && echo "blue" || echo "green")
  kubectl annotate ingress my-app-ingress nginx.ingress.kubernetes.io/canary-weight="100" --overwrite
  exit 1
}

echo "[✓] Rollout completed!"