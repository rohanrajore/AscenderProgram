#!/bin/bash
# Lab 3 teardown — trigger, functions, bucket. Safe to re-run.
PROJECT=$(gcloud config get-value project); R=asia-south1
gcloud eventarc triggers delete on-upload --location=$R --quiet || true
gcloud run services delete gcs-function --region $R --quiet || true
gcloud run services delete hello-function --region $R --quiet || true
gcloud storage rm -r gs://bookshelf-uploads-$PROJECT || true
echo "Lab 3 resources removed."
