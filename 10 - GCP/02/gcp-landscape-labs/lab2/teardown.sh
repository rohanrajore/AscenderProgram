#!/bin/bash
# Lab 2 teardown — the Service first (releases the load balancer), then the cluster.
kubectl delete service hello-web 2>/dev/null || true
gcloud container clusters delete hello-cluster --location asia-south1 --quiet || true
gcloud container clusters list
echo "Lab 2 cluster removed."
