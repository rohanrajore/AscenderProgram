#!/bin/bash
# Lab 4 — A private subnet that can still reach Google. Run block by block in Cloud Shell.
set -euo pipefail
REGION=asia-south1
ZONE=asia-south1-a
PROJECT=$(gcloud config get-value project)

# Step 1 — a custom-mode VPC (no automatic subnets)
gcloud compute networks create bookshelf-vpc --subnet-mode=custom

# Step 2 — one planned subnet: 10.10.0.0/24 (254 usable addresses) in Mumbai
gcloud compute networks subnets create bookshelf-private \
  --network=bookshelf-vpc --region=$REGION --range=10.10.0.0/24

# Step 3 — firewall: SSH only from Google's IAP TCP-forwarding range, nothing else
gcloud compute firewall-rules create bookshelf-allow-iap-ssh \
  --network=bookshelf-vpc --direction=INGRESS --action=ALLOW \
  --rules=tcp:22 --source-ranges=35.235.240.0/20 --target-tags=private-vm

# Step 4 — look at the routes the VPC got for free
gcloud compute routes list --filter="network:bookshelf-vpc"

# Step 5 — a VM with NO external IP
gcloud compute instances create private-vm --zone=$ZONE \
  --machine-type=e2-micro --image-family=debian-12 --image-project=debian-cloud \
  --subnet=bookshelf-private --no-address --tags=private-vm

# Step 6 — SSH in through IAP and prove it cannot reach the internet or Google APIs (yet)
gcloud compute ssh private-vm --zone=$ZONE --tunnel-through-iap \
  --command='curl -s -m 5 -o /dev/null -w "internet: HTTP %{http_code}\n" https://example.com || echo "internet: unreachable (expected)"; curl -s -m 5 -o /dev/null -w "storage api: HTTP %{http_code}\n" https://storage.googleapis.com || echo "storage api: unreachable (expected)"'

# Step 7 — enable Private Google Access on the subnet
gcloud compute networks subnets update bookshelf-private --region=$REGION \
  --enable-private-ip-google-access

# Step 8 — prove Google APIs now work, internet still does not
gcloud compute ssh private-vm --zone=$ZONE --tunnel-through-iap \
  --command='curl -s -m 5 -o /dev/null -w "internet: HTTP %{http_code}\n" https://example.com || echo "internet: unreachable (expected)"; curl -s -m 5 -o /dev/null -w "storage api: HTTP %{http_code}\n" https://storage.googleapis.com; gcloud storage ls 2>&1 | head -3'
