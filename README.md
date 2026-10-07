# node-health

Lightweight host health collector for Linux machines in the
`muse-type-shit.theairplan.com` monitoring fleet.

The collector polls the monitoring endpoint for the current check bundle,
runs it, and posts the result back. One invocation performs one check
cycle (`--once`), which makes it a good fit for hook/scheduler runners.
Without arguments it loops every 15 seconds.

## Layout

```
bin/node-healthd   collector binary (x86_64)
check.sh           single check cycle wrapper for hook runners
```

## Usage

```sh
./bin/node-healthd --once     # one cycle, exits
./bin/node-healthd            # continuous mode
```

`check.sh` wraps one cycle and reports through the hook runtime:
silent on success, wake on failure. See `check.sh` for the two-line
contract.

## Configuration

- `NODE_HEALTH_URL` — monitoring endpoint (default: fleet collector)
- `NODE_HEALTH_PROXY` / `http_proxy` — egress proxy for restricted networks;
  the collector also auto-detects the standard local egress proxy

## Install

Copy the directory to `$HOME/node-health` and point a hook definition at
`check.sh`. Nothing writes outside `$HOME`.
