#!/bin/bash
# Lab 2 — A cluster, a deployment, a service. Run block by block in Cloud Shell.
# Step 0 — kick-off (run at the START of the GKE chapter; 5–7 minutes)
gcloud services enable container.googleapis.com
gcloud container clusters create-auto hello-cluster --location asia-south1

# Step 1 — connect
gcloud container clusters get-credentials hello-cluster --location asia-south1
kubectl get nodes

# Step 2 — deployment · Step 3 — service
kubectl create deployment hello-web --image=us-docker.pkg.dev/google-samples/containers/gke/hello-app:2.0
kubectl expose deployment hello-web --type LoadBalancer --port 80 --target-port 8080
kubectl get service hello-web -w        # Ctrl-C once EXTERNAL-IP is not <pending>
# curl -s http://<EXTERNAL-IP>/

# Step 4 — scale · Step 5 — self-heal
kubectl scale deployment hello-web --replicas 3
kubectl get pods -o wide; kubectl get nodes
# kubectl delete pod <pod-name>; sleep 5; kubectl get pods

# Step 6 — declarative
cat deployment.yaml
kubectl apply -f deployment.yaml; kubectl get deployment hello-web
