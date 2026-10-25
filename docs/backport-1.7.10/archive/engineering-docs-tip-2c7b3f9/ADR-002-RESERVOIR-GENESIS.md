# ADR-002 — Deterministic Reservoir Type Selection and Genesis

Status: ACCEPTED for G3B
Date: 2026-09-10

## Context
The frozen 1.21.1 Petroleum lineage chooses a reservoir type during worldgen after finding a field coordinate, using weighted dimension/biome filters, then derives capacity with `RandomSource.nextFloat()` + `Mth.lerp(min,max)`. The 1.12.2 bridge used numeric dimension ids and Forge `BiomeDictionary.Type` selectors.

Directly copying worldgen RNG ordering would make a 1.7.10 backport dependent on chunk discovery/generation order. That is rejected: the same underground field must materialize identically regardless of exploration direction or which machine discovers it first.

## Decision
Genesis V1 is a deterministic function of:
- world seed;
- numeric 1.7.10 dimension id;
- canonical field anchor;
- frozen reservoir-field algorithm version;
- frozen genesis PRNG algorithm version;
- current eligible reservoir-type registry.

Persisted records remain authoritative after creation. They are never rerolled because registry ordering, filters or defaults later change.

## Filters
Modern empty BWLists mean allow-anywhere; this is preserved exactly.

Dimension filtering uses 1.7.10 numeric dimension ids. Biome filtering accepts exact numeric biome ids and existing `BiomeDictionary.Type` names. Unknown dictionary names are compared as inert strings; the implementation does not call APIs that dynamically create new Forge enum constants as a side effect of a typo.

Defaults transcribed from frozen generated recipes:
- oil: 2,500,000–32,500,000 mB, trace/residual 6, equilibrium 0, weight 40, all dimensions except The End;
- aquifer: 5,000,000–10,000,000 mB, residual 25, equilibrium 2,000,000, weight 30, Overworld only;
- lava: 250,000–1,000,000 mB, residual 0, equilibrium 0, weight 30, all dimensions except The End.

## Deterministic registry
Registry input order is not semantic. Types are sorted by canonical lowercase namespaced id before weighted selection. Duplicate ids and null entries are rejected before selection/sorting.

Adding/removing a type can intentionally alter still-unmaterialized fields because eligibility/weight changed. Existing persisted records do not change. If a persisted type id no longer exists, resolution returns `ORPHANED_TYPE` and leaves the record untouched.

## PRNG and capacity
`ReservoirGenesisRandom` uses a frozen SplitMix64 stream seeded from world seed + dimension + canonical anchor + field version + genesis version. Golden vectors are tests; modifying the stream/call order requires a new genesis algorithm version.
Capacity sampling follows the current-generation shape: a 24-bit `[0,1)` float is consumed and interpolated between min/max with float arithmetic before conversion to an integer quantity. Earlier integer-uniform prototypes were rejected as semantically weaker approximations.

## Intentional deviation from upstream discovery order
The current upstream checks biome/type while scanning the worldgen discovery coordinate before constructing the polygon. This backport instead evaluates eligibility at the canonical anchor. This is deliberate: field identity and genesis must not depend on which chunk happens to discover the connected component first.

## Lazy materialization and performance
`ReservoirResolver` scans deterministic geometry first, checks existing anchor storage, and only creates a shard after a valid genesis plan exists. `OUTSIDE` and `NO_ELIGIBLE_TYPE` do not create save data.

Biome lookup uses `WorldChunkManager.getBiomeGenAt`, not chunk loading. The dedicated probe additionally requires target chunks to remain absent from `World.blockExists` and verifies no corresponding Anvil region file is created on disk.

Field caching is bounded to one seed/field entry, matching the upstream last-seed style. An earlier map-by-seed cache was rejected because it could grow without bound across worlds in one JVM.

## Compatibility rule
`ReservoirNoiseFieldV1` is immutable. A future geometry algorithm must be introduced as a new version with explicit routing/migration; changing V1 in place can make existing canonical anchors unreachable.

G3B does **not** claim fluid registry binding. The modern serializer validates its fluid at load time; actual Forge 1.7.10 fluid registration/resolution is a required G4 Industrial Foundation subgate before Pumpjack extraction can be approved.
