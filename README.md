# Broadcastify Calls node health reports

A common way for a radio recorder (Trunk Recorder Pro, SDRTrunk, SDRTrunk VCE, ...) to tell a
call-collecting service how well it is hearing what it uploads: how much of its control channel
it decodes, how many calls it missed and why, how clean the voice was, and how its radios are
doing. A report goes every five minutes per node, whether or not there were calls.

- **[The specification](node-health.md)** (version 1): when to send, the report's fields, what the
  service answers, and how to send reports to Broadcastify Calls.
- **[Example reports](examples/)**: the conformance cases. A recorder's reports should look like
  them, and Broadcastify takes every one.
- **[`scripts/validate.sh`](scripts/validate.sh)**: checks a report against Broadcastify Calls
  without storing it.

The format isn't specific to Broadcastify: any service can take the same reports, adding only its
own endpoint and credentials (a binding, in the spec's terms).

## Sending to Broadcastify Calls

```
POST https://api.broadcastify.com/call-health
Content-Type: application/json
```

`node` is `{ "systemId": ..., "apiKey": "..." }`: the node's system ID and the API key its calls
are uploaded with. Today Broadcastify logs the reports and stores them for 30 days; they don't yet
change which node's calls are used.

## Testing a report

`?validate=1` runs the same checks as a real report and answers the figures Broadcastify would
work out, without storing anything. It needs no real system ID or key, and has no rate limit.

```bash
scripts/validate.sh examples/p25-trunked.json
```

It answers `200 {"ok":true,"valid":true,"summary":{...}}`, or `400 {"error":"..."}` saying what's
wrong.

## Changes

The spec stays at version 1 while changes are additive or clarifying; see its
[Versions](node-health.md#versions) table. Propose a change with an issue or a pull request.
