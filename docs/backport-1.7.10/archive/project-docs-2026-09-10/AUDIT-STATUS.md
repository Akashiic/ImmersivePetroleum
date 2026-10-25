# Audit Status — 2026-09-09

| Gate | Decision | Evidence / blocker |
|---|---|---|
| G0 Evidence freeze | PASS | 161/161 mod files hashed; 3 upstream revisions frozen; production untouched |
| G1 Skeleton build | PASS | clean build + check + reobf; Java class major 52 |
| G2 Dedicated server | PASS subgate | server reached `Done`, saved/unloaded cleanly |
| G2 Client | BLOCKED | intentionally not executed yet on weak-hardware host |
| G2 Real-world upgrade | BLOCKED | no copied production world has been subjected to this addon yet |
| G3A Reservoir domain / field / scanner | PASS | 250k Python + JUnit campaigns; 268,435,456-column footprint campaign; bounded canonical scanner |
| G3A Forge persistence | PASS | final 5-boot automated campaign: same-session reopen, restart, mutate, restart, corruption fail-closed, recovery |
| G3B Type registry / genesis | BLOCKED | type filtering and deterministic creation service not implemented yet |
| G4 Pumpjack | BLOCKED | architecture/source lineage audited; production implementation not written |
| Asset redistribution | BLOCKED | current distribution marked All Rights Reserved; no root repo license discovered |

## Rejected evidence
The first modpack hash snapshot omitted eight filenames containing `[` / `]` because PowerShell wildcard semantics were used. That run was rejected. The collector was corrected to `Get-FileHash -LiteralPath`; only the 161/161 snapshot is admissible.

The first corruption campaign was also rejected as a passing artifact: Forge 1.7.10 `MapStorage.loadData` instantiates `WorldSavedData` before GZIP decode. On decompression failure it can return an empty object shell instead of null. Our first store therefore misclassified the corrupt shard as `FOUND` and the probe failed later with `record missing`.

## G3A adversarial repairs
Repair 1: `ReservoirRegionData` now has an explicit initialization state. A raw constructor instance is only a reflection shell; only `createNew()` or successful entry into `readFromNBT()` initializes it. Existing file + uninitialized shell is `UNREADABLE`. The corrupt-file hash remained unchanged through the failure, proving the store did not overwrite it.

Repair 2: a pre-commit review found that using only `readFromNBTWasInvoked` would falsely reject a newly created shard after it had been saved and reopened within the same JVM. That design was rejected before commit. The final model uses `initializedForUse`, and the write probe explicitly saves then reopens the shard in the same server process before declaring PASS.

Final campaign source-of-truth: `evidence/g3a-reservoir-final`. The accepted valid shard SHA-256 is `9e9d4b16e2a6600d7ec9b1256c0c917ce60eeb0cdcf1ae402c8d4a2198ec76f5`; the intentional-corruption payload hash was `a186a1cea95d58343c5b056b18fef1c750a1612ef955e08bf6b426a75d3ef141`.

## Non-blocking observations
- Forge's legacy online version check emits malformed-JSON noise in the dev runtime.
- First-run server metadata JSON files may emit normal file-not-found warnings.
- `runServer`/Gradle can exit 0 even when FML reports a mod exception; therefore runtime probes are judged from explicit PASS markers and FML error content, never Gradle exit code alone.

## Approval rule
No future row can be promoted from BLOCKED/FAIL to PASS by visual inspection alone when persistence, conservation, networking or server classloading is applicable.
