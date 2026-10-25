# ADR-001 — Reservoir Identity and Persistence

Status: ACCEPTED for G3A
Date: 2026-09-09

## Context
Immersive Petroleum 1.12.2 stores per-deposit state in a global cache serialized through one `WorldSavedData`. The frozen 1.21.1 lineage moved to polygon-shaped reservoirs and 512x512 region storage. Our 1.7.10 implementation must preserve modern field semantics without creating a single unbounded save object or requiring loaded chunks for lookup.

## Decision
Use a deterministic reservoir field (`ReservoirNoiseFieldV1`) and derive a canonical component anchor with a bounded iterative four-neighbour scan. Persist only identity and mutable state:
- algorithm version;
- canonical anchor X/Z;
- namespaced reservoir type id;
- capacity and current amount;
- infinite-mode state and flow rate;
- last equalization tick.

Do not persist the component polygon in schema v1. Geometry is deterministic and can be reconstructed from world seed + algorithm version. Type configuration such as residual/equilibrium remains in `ReservoirType`, matching modern semantics, so balance updates can affect existing reservoirs without rewriting every record.

## Storage layout
Use `World.perWorldStorage`, not shared `mapStorage`. Forge 1.7.10 constructs `perWorldStorage` with `WorldSpecificSaveHandler`, which saves under each dimension's chunk-save directory. Shards use the modern 512-block scale:

`immersivepetroleum-reservoir-region-v1-<regionX>_<regionZ>.dat`

Each record is owned by the shard containing its canonical anchor. Cross-shard insertion is rejected.

## Corruption policy
`MapStorage.loadData` is not trusted to distinguish missing from unreadable files. Before load, `ReservoirRegionStore` checks whether the expected file exists. A raw `ReservoirRegionData(String)` is an uninitialized reflection shell; only `createNew()` or entry through `readFromNBT()` marks an instance initialized. Existing file + returned uninitialized shell => `UNREADABLE`. This distinction also keeps a newly-created-and-saved object valid when it is reopened from the in-memory `MapStorage` cache during the same JVM session.

Unknown schema, mismatched region identity, duplicate anchors or record decode failures make a shard INVALID/read-only. Invalid data is not exposed and cannot be serialized by the shard object.

The automated acceptance probe covers: create + save + same-session reopen, process restart/read, mutation/save, second restart/read, intentional non-GZIP corruption classified as `UNREADABLE` with byte-for-byte hash preservation, valid-backup restoration, and final recovery read.

## Performance policy
The component scan is discovery-only and capped at 65,536 columns. The 64-seed/2048-side campaign sampled 268,435,456 columns and observed 76,737 complete components; max observed area was 3,238 columns, max width 137 and max depth 101. This evidence supports the cap and 512-region scale but is not treated as a mathematical proof of maximum possible component size.


## Infinite extraction safety adaptation
The frozen 1.21.1 `Reservoir.extract` path returns the configured infinite flow rate directly for an infinite reservoir, even if the caller requested less. The 1.7.10 backport intentionally returns `min(requested, infiniteFlowRate)` for both SIMULATE and EXECUTE. This preserves the infinite-reservoir concept while maintaining the consumer contract that a source must never report more fluid than requested. Infinite extraction does not mutate stored amount, and infinite reservoirs report zero hydrostatic pressure to the Derrick/Pumpjack pressure path.