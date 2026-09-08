#!/bin/bash
# Lab 5 — Postgres from psql, then Firestore documents. Run block by block in Cloud Shell.
PROJECT=$(gcloud config get-value project)

# Step 0 — kick-off (run at the START of the storage chapter; 5–10 minutes)
gcloud services enable sqladmin.googleapis.com firestore.googleapis.com
gcloud sql instances create bookshelf-pg --database-version=POSTGRES_17 --tier=db-f1-micro \
  --region=asia-south1 --edition=ENTERPRISE --root-password='Bookshelf#2026'

# Step 1 — database + connect (password: Bookshelf#2026). Then paste books.sql at the psql prompt, \q to leave.
gcloud sql databases create bookshelf --instance=bookshelf-pg
gcloud sql connect bookshelf-pg --user=postgres --database=bookshelf

# Step 3 — backup + describe
gcloud sql backups create --instance=bookshelf-pg
gcloud sql instances describe bookshelf-pg --format='value(ipAddresses[0].ipAddress,gceZone,settings.tier)'

# Step 4 — Firestore database; then add book-1 and book-2 in the console (Firestore → Data → Start collection: books)
gcloud firestore databases create --location=asia-south1 --type=firestore-native

# Step 5 — read + query via REST
TOKEN=$(gcloud auth print-access-token)
FS="https://firestore.googleapis.com/v1/projects/$PROJECT/databases/(default)/documents"
curl -s -H "Authorization: Bearer $TOKEN" "$FS/books" | head -30
curl -s -X POST -H "Authorization: Bearer $TOKEN" -H 'Content-Type: application/json' "$FS:runQuery" \
  -d '{"structuredQuery":{"from":[{"collectionId":"books"}],"where":{"fieldFilter":{"field":{"fieldPath":"year"},"op":"GREATER_THAN_OR_EQUAL","value":{"integerValue":"2017"}}}}}'
