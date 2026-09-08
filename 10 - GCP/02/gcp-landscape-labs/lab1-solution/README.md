# Lab 1 — A VM, then a fleet (solution)

Complete `lab1.sh`. Run block by block in Cloud Shell; `bash teardown.sh` at the end.
Expected: `gcloud compute instance-groups managed list-instances bookshelf-mig` shows two instances with STATUS `RUNNING`; after `set-autoscaling` with min 1, the group shrinks to 1 within a few minutes because the VMs are idle.
