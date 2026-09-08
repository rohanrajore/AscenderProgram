#!/bin/bash
# Lab 4 — A private subnet that can still reach Google. Run block by block in Cloud Shell.
# Fill every TODO(lab-4.N) before running that step. Answers on the reveal slide.
set -euo pipefail
REGION=asia-south1
ZONE=asia-south1-a
PROJECT=$(gcloud config get-value project)

# Step 1 — a custom-mode VPC (no automatic subnets)
gcloud compute networks create bookshelf-vpc --subnet-mode=custom

# Step 2 — one planned subnet: 254 usable addresses in Mumbai
# TODO(lab-4.2): give the subnet a /24 range inside 10.0.0.0/8
gcloud compute networks subnets create bookshelf-private \
  --network=bookshelf-vpc --region=$REGION --range=______

# Step 3 — firewall: SSH only from Google's IAP TCP-forwarding range 35.235.240.0/20, nothing else
# TODO(lab-4.3): fill the port and the source range
gcloud compute firewall-rules create bookshelf-allow-iap-ssh \
  --network=bookshelf-vpc --direction=INGRESS --action=ALLOW \
  --rules=tcp:______ --source-ranges=______ --target-tags=private-vm

# Step 4 — look at the routes the VPC got for free
gcloud compute routes list --filter="network:bookshelf-vpc"

# Step 5 — a VM with NO external IP
# TODO(lab-4.5): add the flag that removes the external IP
gcloud compute instances create private-vm --zone=$ZONE \
  --machine-type=e2-micro --image-family=debian-12 --image-project=debian-cloud \
  --subnet=bookshelf-private ______ --tags=private-vm

# Step 6 — SSH in through IAP and prove it cannot reach the internet or Google APIs (yet)
gcloud compute ssh private-vm --zone=$ZONE --tunnel-through-iap \
  --command='curl -s -m 5 -o /dev/null -w "internet: HTTP %{http_code}\n" https://example.com || echo "internet: unreachable (expected)"; curl -s -m 5 -o /dev/null -w "storage api: HTTP %{http_code}\n" https://storage.googleapis.com || echo "storage api: unreachable (expected)"'

# Step 7 — enable Private Google Access on the subnet
# TODO(lab-4.7): add the flag that turns on Private Google Access
gcloud compute networks subnets update bookshelf-private --region=$REGION ______

# Step 8 — prove Google APIs now work, internet still does not
gcloud compute ssh private-vm --zone=$ZONE --tunnel-through-iap \
  --command='curl -s -m 5 -o /dev/null -w "internet: HTTP %{http_code}\n" https://example.com || echo "internet: unreachable (expected)"; curl -s -m 5 -o /dev/null -w "storage api: HTTP %{http_code}\n" https://storage.googleapis.com; gcloud storage ls 2>&1 | head -3'
