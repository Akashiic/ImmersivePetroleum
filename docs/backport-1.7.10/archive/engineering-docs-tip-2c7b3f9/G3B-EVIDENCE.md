# G3B Evidence — Type Registry and Deterministic Genesis

Status: ACCEPTED for 0.1.0-alpha.2
Date: 2026-09-10

## Source verification
Frozen 1.21.1 `ReservoirSerializer` maps:
- `fluidminimum` -> min size;
- `fluidcapacity` -> max size;
- `fluidtrace` -> residual;
- `equilibrium` -> equilibrium;
- `weight` -> weight.

Frozen BWList source confirms an empty selector list accepts any target. The 1.12.2 bridge confirms numeric dimension ids and Forge BiomeDictionary selectors are native compatibility primitives for this generation.

## Automated tests
Current complete suite: **45 tests / 0 failures / 0 errors**.

G3B adds coverage for PRNG golden vectors, 24-bit float sampling, whitelist/blacklist semantics, BiomeDictionary behavior, canonical ids, duplicate/null type rejection, registration-order independence, deterministic genesis and a 250,000-run distribution/capacity campaign.

## Dedicated genesis campaign
Fixed dev world seed: `1234567890123456789`.

Accepted final pre-tag run:
- query target: `100079,100000`;
- canonical anchor: `100053,99972`;
- selected type: `immersivepetroleum:oil`;
- deterministic capacity: `20,450,302 mB`;
- amount after audited extraction of 1,234 mB: `20,449,068 mB`;
- final shard SHA-256: `afecf49cb33f6c401f43f881e143eda6449beb7177831a3ad40c7a3709a61edc`.

The campaign requires three independent server boots: CREATED + same-session existing lookup; restart FOUND_EXISTING + conservation mutation; restart FOUND_EXISTING + persisted mutation + orphaned-type protection.

The query and a directly-connected sibling are deliberately selected across a chunk boundary. `blockExists` remains false before/after lookup, and the harness rejects creation of the corresponding target Anvil region file. The End returns `NO_ELIGIBLE_TYPE`; no End reservoir shard or target Anvil region is created.

## G3A regression
After final G3B genesis semantics, the full five-boot G3A corruption campaign passed again:
- valid shard SHA-256: `9e9d4b16e2a6600d7ec9b1256c0c917ce60eeb0cdcf1ae402c8d4a2198ec76f5`;
- intentional corruption SHA-256: `a186a1cea95d58343c5b056b18fef1c750a1612ef955e08bf6b426a75d3ef141`;
- corrupt data remained fail-closed and the valid backup recovered successfully.

## Rejected implementations found by audit
1. Integer-uniform capacity with inclusive max was rejected after comparing with current `nextFloat + lerp` source semantics.
2. Integer-uniform capacity with exclusive max was rejected as closer but still not the current float sampling behavior.
3. Unbounded map keyed by world seed for field cache was rejected and replaced with a one-entry cache.
4. Null reservoir type validation after sorting was rejected because null could reach the comparator first; validation now happens before sorting.
5. Earlier dedicated campaign value `25,011,864 mB` was superseded because it came from the rejected integer-capacity approximation.

## Remaining boundary
Fluid ids are syntax-valid and persisted, but `immersivepetroleum:crudeoil` is not registered by this addon yet. G3B therefore approves deterministic identity/genesis only. Fluid registry binding is explicitly blocked until the G4 Industrial Foundation subgate.


## Alpha.2 final validation
After the version bump to `0.1.0-alpha.2`, a clean `check build` passed with 45 tests / 0 failures / 0 errors. The dedicated genesis campaign passed again with capacity `20,450,302 mB`, final amount `20,449,068 mB`, and shard SHA-256 `afecf49cb33f6c401f43f881e143eda6449beb7177831a3ad40c7a3709a61edc`. The full G3A corruption/persistence campaign also passed again with valid shard SHA-256 `9e9d4b16e2a6600d7ec9b1256c0c917ce60eeb0cdcf1ae402c8d4a2198ec76f5`.
