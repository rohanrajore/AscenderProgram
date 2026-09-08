#!/bin/bash
# Optional extra — Memorystore (Redis), reachable only from inside the VPC. Run block by block.
gcloud services enable redis.googleapis.com
gcloud redis instances create bookshelf-cache --size=1 --region=asia-south1 --network=default   # ~5 min
HOST=$(gcloud redis instances describe bookshelf-cache --region=asia-south1 --format='value(host)'); echo $HOST
gcloud compute instances create cache-client --zone=asia-south1-a --machine-type=e2-micro --image-family=debian-12 --image-project=debian-cloud
gcloud compute ssh cache-client --zone=asia-south1-a --command="sudo apt-get install -y -q redis-tools >/dev/null && redis-cli -h $HOST SET book:1 'Release It!' EX 300 && redis-cli -h $HOST GET book:1"
# teardown
gcloud compute instances delete cache-client --zone=asia-south1-a --quiet
gcloud redis instances delete bookshelf-cache --region=asia-south1 --quiet
