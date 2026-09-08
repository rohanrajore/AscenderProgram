# Compute, Storage, Networking and the Deployment Landscape — all lab kits (v2)

Every lab is console or Cloud Shell only. Scripts are command sheets to run block by block, never all at once.

- lab0/lab0.sh — project, region, APIs, toolchain check
- lab1-starter/ · lab1-solution/ — VM, template, MIG, autoscaler (lab1.sh with three blanks / completed; startup.sh supplied; teardown.sh)
- lab2/ — GKE: lab2.sh (kick-off + steps), deployment.yaml (supplied), teardown.sh
- lab3/ — Cloud Run functions: hello-function/, gcs-function/ (supplied complete), lab3.sh, teardown.sh
- lab4-starter/ · lab4-solution/ — private subnet + Private Google Access (lab4.sh with four blanks / completed; teardown.sh)
- lab5/ — Cloud SQL Postgres + Firestore: lab5.sh (kick-off + steps), books.sql, teardown.sh, memorystore-optional.sh
- teardown-all.sh — end-of-session cleanup in cost order, then the verification lists

Upload the zip to Cloud Shell (⋮ → Upload), then: unzip -q gcp-landscape-labs-all.zip && cd gcp-landscape-labs
