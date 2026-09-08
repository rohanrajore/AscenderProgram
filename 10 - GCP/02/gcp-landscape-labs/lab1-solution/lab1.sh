#!/bin/bash
# Lab 1 — A VM, then a fleet. Run line by line in Cloud Shell.
set -euo pipefail
REGION=asia-south1
ZONE=asia-south1-a
gcloud config set compute/region $REGION
gcloud config set compute/zone $ZONE

# Step 1 — one VM
gcloud compute instances create bookshelf-vm \
  --machine-type=e2-micro \
  --image-family=debian-12 --image-project=debian-cloud \
  --boot-disk-size=10GB --boot-disk-type=pd-balanced \
  --tags=http-server \
  --metadata-from-file=startup-script=startup.sh

# Step 2 — allow HTTP to anything tagged http-server
gcloud compute firewall-rules create allow-http-80 \
  --network=default --direction=INGRESS --action=ALLOW \
  --rules=tcp:80 --source-ranges=0.0.0.0/0 --target-tags=http-server

# Step 3 — look at it
gcloud compute instances list
gcloud compute instances describe bookshelf-vm --format="value(networkInterfaces[0].accessConfigs[0].natIP)"

# Step 4 — an instance template (same recipe, reusable)
gcloud compute instance-templates create bookshelf-tmpl \
  --machine-type=e2-small \
  --image-family=debian-12 --image-project=debian-cloud \
  --tags=http-server \
  --metadata-from-file=startup-script=startup.sh

# Step 5 — a managed instance group of 2
gcloud compute instance-groups managed create bookshelf-mig \
  --template=bookshelf-tmpl --size=2 --zone=$ZONE

# Step 6 — autoscale on CPU, 1..3
gcloud compute instance-groups managed set-autoscaling bookshelf-mig \
  --zone=$ZONE --min-num-replicas=1 --max-num-replicas=3 \
  --target-cpu-utilization=0.6 --cool-down-period=60

# Step 7 — watch it
gcloud compute instance-groups managed list-instances bookshelf-mig --zone=$ZONE
