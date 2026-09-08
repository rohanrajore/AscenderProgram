# Lab 1 — A VM, then a fleet (starter)

Environment: Cloud Shell in your sandbox project. Nothing to install.

1. `unzip gcp-landscape-lab1-starter.zip && cd lab1`
2. Open `lab1.sh`, fill each `TODO(lab-1.N)` blank, then run the steps one block at a time (copy-paste into Cloud Shell).
3. Expected at the end: `list-instances` shows 2 VMs `RUNNING` in `bookshelf-mig`; the VM's external IP serves "Bookshelf baseline".
4. Finish with `bash teardown.sh`. Cost of leaving it running: about 3 small VMs ≈ US$1/day — so don't.

Verify first: `gcloud --version` prints `Google Cloud SDK 583.x` or later.
