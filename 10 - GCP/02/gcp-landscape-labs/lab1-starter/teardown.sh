#!/bin/bash
# Lab 1 teardown — removes everything Lab 1 created. Safe to re-run.
ZONE=asia-south1-a
gcloud compute instance-groups managed delete bookshelf-mig --zone=$ZONE --quiet || true
gcloud compute instance-templates delete bookshelf-tmpl --quiet || true
gcloud compute instances delete bookshelf-vm --zone=$ZONE --quiet || true
gcloud compute firewall-rules delete allow-http-80 --quiet || true
echo "Lab 1 resources removed."
