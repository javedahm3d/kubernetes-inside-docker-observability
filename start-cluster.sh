#!/bin/bash
set -e

echo "[INFO] Starting Docker daemon..."
dockerd --host=tcp://0.0.0.0:2375 --host=unix:///var/run/docker.sock &

# Wait for Docker daemon
echo "[INFO] Waiting for Docker to be ready..."
for i in {1..20}; do
    docker info >/dev/null 2>&1 && break
    echo "Waiting for Docker... ($i/20)"
    sleep 1
done

echo "[INFO] Creating k3d cluster..."
k3d cluster create wiki-cluster \
    --wait \
    -p "8080:80@loadbalancer" \
    -p "6443:6443@loadbalancer"

echo "[INFO] Deploying wiki-service..."
# Build & load wiki-service Docker image into k3d
docker build -t wiki-service:latest /wiki-service
k3d image import wiki-service:latest -c wiki-cluster



echo "[INFO] Deploying wiki-chart (Helm chart)..."
# Install Helm chart, override image name to use locally built image
helm install wiki-chart /wiki-chart \
    --namespace wiki \
    --create-namespace \
    --set fastapi.image_name=wiki-service:latest

echo "[INFO] Cluster and services are ready!"
kubectl get pods -n wiki

# Keep container alive
tail -f /dev/null
