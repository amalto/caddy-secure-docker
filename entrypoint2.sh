#!/bin/sh
# Check custom start script(s)
echo "Checking for custom script(s) in /data/script.d..."
scripts=$(ls -l /data/script.d | egrep '^-' | awk '{print $9}')
for script in ${scripts}; do
  echo "  Running custom script ${script}..."
  chmod +x "/data/script.d/${script}"
  . "/data/script.d/${script}"
done

/usr/bin/caddy run -config /etc/caddy/Caddyfile
