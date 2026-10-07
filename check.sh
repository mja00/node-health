#!/usr/bin/env bash
# node-health check — one monitoring cycle, reported through the hook runtime.
# Silent when the check succeeds; wakes the agent only when the collector fails.
set -u
D="$(cd "$(dirname "$0")" && pwd)"
RT="${HOOK_RUNTIME:-$HOME/hooks/runtime/hatch_hook_runtime.sh}"
# shellcheck disable=SC1090
[ -r "$RT" ] && . "$RT"
out="$("$D/bin/node-healthd" --once 2>&1)"
rc=$?
if [ "$rc" = 0 ]; then
  command -v silent >/dev/null 2>&1 && silent "node-health ok" || true
else
  if command -v wake >/dev/null 2>&1; then
    wake "node-health check failed" "{\"exit\":$rc,\"output\":\"$(printf '%s' "$out" | head -c 300 | tr -d '\n')\"}"
  fi
fi
exit "$rc"
