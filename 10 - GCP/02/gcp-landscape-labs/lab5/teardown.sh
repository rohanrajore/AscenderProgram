#!/bin/bash
# Lab 5 teardown — the Cloud SQL instance (billed while it exists) and the Firestore database.
gcloud sql instances delete bookshelf-pg --quiet || true
gcloud firestore databases delete --database='(default)' --quiet || true
gcloud sql instances list
echo "Lab 5 resources removed."
