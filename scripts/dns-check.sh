#!/usr/bin/env bash
# dns-check.sh — Resolve hostnames and print DNS record details for lab debugging.
set -euo pipefail

HOSTS="${1:-localhost backend nginx google.com}"
TIMEOUT="${DNS_TIMEOUT:-3}"

echo "=== DNS Check ==="
echo "Hosts: $HOSTS"
echo "Timeout: ${TIMEOUT}s"
echo

for host in $HOSTS; do
  echo "--- $host ---"

  if command -v dig >/dev/null 2>&1; then
    dig +time="$TIMEOUT" +tries=1 +short A "$host" 2>/dev/null | sed 's/^/  A: /' || echo "  A: (no answer)"
    dig +time="$TIMEOUT" +tries=1 +short CNAME "$host" 2>/dev/null | sed 's/^/  CNAME: /' || true
  elif command -v nslookup >/dev/null 2>&1; then
    nslookup "$host" 2>/dev/null | tail -n +3 | sed 's/^/  /'
  else
    echo "  (dig/nslookup not found — install bind-tools)"
  fi

  if command -v getent >/dev/null 2>&1; then
    getent hosts "$host" 2>/dev/null | sed 's/^/  getent: /' || echo "  getent: (no entry)"
  fi

  echo
done

echo "Tip: From inside the nginx container, run: getent hosts backend"
