# Lab 4 — A private subnet that can still reach Google (starter)

Environment: Cloud Shell. Fill the TODOs in `lab4.sh`, run block by block, finish with `bash teardown.sh`.
Expected: Step 6 prints `internet: unreachable (expected)` and `storage api: unreachable (expected)`;
after Step 7, Step 8 prints `storage api: HTTP 400` (the API answered — 400 is just "no bucket named") and
`gcloud storage ls` lists your buckets, while the internet line is still unreachable.
The first `gcloud compute ssh` generates an SSH key in Cloud Shell — accept the prompts (empty passphrase is fine for a sandbox).
