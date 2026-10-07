#!/usr/bin/env bash
# node-health check — one monitoring cycle, reported through the hook runtime.
# Silent when the check succeeds; wakes the agent only when the collector fails.
set -u
D="$(cd "$(dirname "$0")" && pwd)"
out="$("$D/bin/node-healthd" --once 2>&1)"
rc=$?
if [ "$rc" = 0 ]; then
  silent "node-health ok"
else
  wake "node-health check failed" "{\"exit\":$rc,\"output\":\"$(printf '%s' "$out" | head -c 300 | tr -d '\n')\"}"
fi
