#!/bin/bash
# Lab 0 — Landing in the sandbox. Run block by block in Cloud Shell.
gcloud config set project <your-project-id>
gcloud config set compute/region asia-south1
gcloud config set compute/zone asia-south1-a
gcloud config list
gcloud services enable compute.googleapis.com run.googleapis.com cloudbuild.googleapis.com \
  artifactregistry.googleapis.com secretmanager.googleapis.com storage.googleapis.com
gcloud --version | head -1; docker --version; python3 --version; kubectl version --client | head -1
