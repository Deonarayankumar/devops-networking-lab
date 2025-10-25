#!/usr/bin/env bash
# http-debug.sh — Verbose HTTP request with timing and header inspection.
set -euo pipefail

URL="${1:-http://localhost:8080/health}"
METHOD="${2:-GET}"

echo "=== HTTP Debug ==="
echo "URL:    $URL"
echo "Method: $METHOD"
echo

if ! command -v curl >/dev/null 2>&1; then
  echo "curl is required but not installed."
  exit 1
fi

echo "--- Response headers ---"
curl -sS -o /dev/null -D - -X "$METHOD" "$URL" | sed 's/\r$//'

echo
echo "--- Body ---"
curl -sS -X "$METHOD" "$URL"
echo

echo "--- Timing ---"
curl -sS -o /dev/null -w \
  "dns: %{time_namelookup}s\nconnect: %{time_connect}s\nssl: %{time_appconnect}s\nttfb: %{time_starttransfer}s\ntotal: %{time_total}s\n" \
  -X "$METHOD" "$URL"
