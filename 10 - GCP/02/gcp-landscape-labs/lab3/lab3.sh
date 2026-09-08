#!/bin/bash
# Lab 3 — An HTTP function, then a function that reacts to an upload. Run block by block from the lab3 folder.
PROJECT=$(gcloud config get-value project)
PN=$(gcloud projects describe $PROJECT --format='value(projectNumber)')
R=asia-south1

# Step 2 — HTTP function
(cd hello-function && gcloud run deploy hello-function --source . --function hello --base-image python313 --region $R --allow-unauthenticated)
curl -s "$(gcloud run services describe hello-function --region $R --format='value(status.url)')/?name=bookshelf"; echo

# Step 3 — bucket
gcloud storage buckets create gs://bookshelf-uploads-$PROJECT --location=$R --uniform-bucket-level-access

# Step 4 — the three grants
gcloud projects add-iam-policy-binding $PROJECT --member=serviceAccount:$(gcloud storage service-agent) --role=roles/pubsub.publisher
gcloud projects add-iam-policy-binding $PROJECT --member=serviceAccount:$PN-compute@developer.gserviceaccount.com --role=roles/eventarc.eventReceiver
gcloud projects add-iam-policy-binding $PROJECT --member=serviceAccount:$PN-compute@developer.gserviceaccount.com --role=roles/run.invoker

# Step 5 — event function + trigger
(cd gcs-function && gcloud run deploy gcs-function --source . --function on_upload --base-image python313 --region $R --no-allow-unauthenticated)
gcloud eventarc triggers create on-upload --location=$R --destination-run-service=gcs-function --destination-run-region=$R \
  --event-filters="type=google.cloud.storage.object.v1.finalized" --event-filters="bucket=bookshelf-uploads-$PROJECT" \
  --service-account=$PN-compute@developer.gserviceaccount.com

# Step 6 — upload, read the log (the first trigger can take up to 2 minutes to become active)
echo hello > note.txt; gcloud storage cp note.txt gs://bookshelf-uploads-$PROJECT/; sleep 30
gcloud run services logs read gcs-function --region $R --limit 5
