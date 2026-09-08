#!/bin/bash
# Startup script for the Bookshelf baseline VM / MIG template.
# Serves one page on port 80 that says which VM answered.
apt-get update -y && apt-get install -y python3
mkdir -p /srv/www
cat > /srv/www/index.html <<HTML
<h1>Bookshelf baseline</h1>
<p>Served by VM: $(hostname)</p>
HTML
cd /srv/www && nohup python3 -m http.server 80 >/var/log/bookshelf.log 2>&1 &
