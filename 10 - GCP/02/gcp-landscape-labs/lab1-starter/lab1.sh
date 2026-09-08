#!/bin/bash
# Lab 1 — A VM, then a fleet. Run line by line in Cloud Shell.
# Fill every TODO(lab-1.N) before running that step. Answers are on the reveal slide.
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
# TODO(lab-1.4): create an instance template named bookshelf-tmpl, e2-small, debian-12,
#                tag http-server, startup script startup.sh
gcloud compute instance-templates create bookshelf-tmpl \
  --machine-type=______ \
  --image-family=______ --image-project=______ \
  --tags=http-server \
  --metadata-from-file=startup-script=startup.sh

# Step 5 — a managed instance group of 2
# TODO(lab-1.5): create a zonal MIG named bookshelf-mig from that template with 2 VMs
gcloud compute instance-groups managed create bookshelf-mig \
  --template=______ --size=______ --zone=$ZONE

# Step 6 — autoscale on CPU, 1..3 replicas, target 60% CPU, 60 s cooldown
# TODO(lab-1.6): fill the four autoscaling flags
gcloud compute instance-groups managed set-autoscaling bookshelf-mig \
  --zone=$ZONE --min-num-replicas=______ --max-num-replicas=______ \
  --target-cpu-utilization=______ --cool-down-period=______

# Step 7 — watch it
gcloud compute instance-groups managed list-instances bookshelf-mig --zone=$ZONE
