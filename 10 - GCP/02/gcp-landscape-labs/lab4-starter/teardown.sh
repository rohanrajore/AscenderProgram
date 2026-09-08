#!/bin/bash
# Lab 4 teardown. Order matters: VM, then firewall rule, then subnet, then network.
REGION=asia-south1
ZONE=asia-south1-a
gcloud compute instances delete private-vm --zone=$ZONE --quiet || true
gcloud compute firewall-rules delete bookshelf-allow-iap-ssh --quiet || true
gcloud compute networks subnets delete bookshelf-private --region=$REGION --quiet || true
gcloud compute networks delete bookshelf-vpc --quiet || true
echo "Lab 4 network removed."
