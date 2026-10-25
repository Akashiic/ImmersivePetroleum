# G3A Evidence — Deterministic Reservoir Core

Decision: **PASS**
Accepted source state: `feature/reservoir-v1` immediately before the G3A commit.
Full binary/log evidence: `evidence/g3a-reservoir-final`.

## Automated tests
- JUnit suites: 28 tests total, 0 failures, 0 errors.
- Python domain property campaign: 250,000 randomized reservoir operations.
- Java randomized conservation campaign: 100,000 operations inside JUnit.
- Simplex parity: 25,000 randomized generic-coordinate samples against Minecraft 1.7.10 `NoiseGeneratorSimplex`, with exact-integer negative-boundary behavior intentionally implemented using modern mathematical floor.

## Spatial campaign
Frozen 1.21.1-equivalent field sampled over 64 deterministic seeds × 2048 × 2048 columns = 268,435,456 samples.
Observed complete components: 76,737; boundary-censored: 3,608; active ratio ≈ 0.10716873.
Area p50/p95/p99/max: 268 / 843 / 1,294 / 3,238 columns.
Width p50/p95/p99/max: 20 / 49 / 54 / 137 blocks.
Depth p50/p95/p99/max: 20 / 49 / 51 / 101 blocks.
These measurements support, but do not mathematically prove, the 65,536-column hard scan cap and 512-block shard scale.

## Dedicated-server persistence campaign
The final automated campaign ran five isolated server boots against `ip-persistence-probe`:
1. create + save + reopen the shard in the same JVM;
2. restart, read the original 12,345,678 mB, extract 12,345 mB, mark dirty and save;
3. restart and verify 12,333,333 mB;
4. replace the shard with intentional non-GZIP bytes and require `UNREADABLE`; verify its SHA-256 is unchanged through the failed load;
5. restore the valid backup byte-for-byte and restart, verifying 12,333,333 mB again.

Harness verdict: `PERSISTENCE_CAMPAIGN_PASS`.
Accepted valid shard SHA-256: `9e9d4b16e2a6600d7ec9b1256c0c917ce60eeb0cdcf1ae402c8d4a2198ec76f5`.
Intentional corruption SHA-256: `a186a1cea95d58343c5b056b18fef1c750a1612ef955e08bf6b426a75d3ef141`.
The release JAR hash is intentionally not recorded here: the authoritative artifact is produced only after the clean `0.1.0-alpha.1` tag exists, then captured in the external evidence manifest.

## Audit defects caught before approval
- first hash inventory omitted bracket-named JARs: rejected and rebuilt 161/161;
- first corrupt-shard detector trusted `MapStorage` null semantics: rejected after adversarial failure;
- first fix used only `readFromNBT` invocation as a sentinel: rejected in pre-commit review because same-session cached objects can be valid without a read call;
- final design uses explicit initialization provenance (`createNew` or NBT load) and passed the repeated campaign.
