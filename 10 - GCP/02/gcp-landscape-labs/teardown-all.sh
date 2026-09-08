#!/bin/bash
# End-of-session teardown for every lab, most expensive first. Safe to re-run.
bash lab2/teardown.sh
bash lab5/teardown.sh
bash lab3/teardown.sh
(cd lab4-solution && bash teardown.sh)
(cd lab1-solution && bash teardown.sh)
echo "--- verify (all should be empty; networks shows only 'default') ---"
gcloud compute instances list; gcloud container clusters list; gcloud run services list; gcloud sql instances list; gcloud storage ls; gcloud compute networks list
