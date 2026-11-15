#!/usr/bin/env bash
# Check a node health report against Broadcastify Calls without storing it:
#   scripts/validate.sh report.json
#   some-recorder --print-report | scripts/validate.sh -
# Validate mode needs no real system ID or API key, has no rate limit and stores nothing.
# Prints the answer (the figures Broadcastify works out, or what's wrong) and exits 0 only
# when the report is valid.
set -euo pipefail

URL="${NODE_HEALTH_URL:-https://api.broadcastify.com/call-health}?validate=1"
file="${1:-}"
if [ -z "$file" ]; then
  echo "usage: $0 report.json   (or - for stdin)" >&2
  exit 2
fi

out=$(mktemp)
trap 'rm -f "$out"' EXIT
status=$(curl -sS -o "$out" -w '%{http_code}' -X POST -H 'Content-Type: application/json' \
  --data-binary @"$file" "$URL")

if command -v jq >/dev/null 2>&1; then jq . "$out" 2>/dev/null || cat "$out"; else cat "$out"; echo; fi
if [ "$status" = 200 ]; then
  echo "valid (HTTP 200)" >&2
else
  echo "not valid (HTTP $status)" >&2
  exit 1
fi
