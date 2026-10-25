# Engineering Roadmap / Approval Gates

## Gate state legend
- `PASS`: evidence satisfies current exit criteria.
- `FAIL`: a concrete defect blocks advancement.
- `BLOCKED`: prerequisite gate is incomplete.
- `PLANNED`: not yet executed.

## G0 â€” Evidence and workspace freeze
Current status: **PASS**

Exit evidence:
- actual Forbidden Series mod directory inventoried: 161 files / 161 hashes / 0 null hashes;
- exact current IE development dependency frozen by SHA-256;
- upstream 1.21.1, 1.12.2 and legacy master cloned separately with commit IDs recorded;
- no production modpack JAR modified;
- independent Git/RFG workspace created.

Audit incident: first hash pass omitted eight JARs whose names contain square brackets because PowerShell wildcard semantics were used. That run was REJECTED. The collector was corrected to `-LiteralPath` and the complete 161/161 snapshot replaced it.

## G1 â€” Reproducible skeleton build
Current status: **PASS (compile/reobf only)**

Evidence:
- `gradlew clean build --stacktrace`: exit code 0;
- `compileJava`, `check`, `jar`, `reobfJar` and `build` completed;
- generated production class major version = 52 (Java 8);
- minimal addon depends on `ImmersiveEngineering` and has no gameplay registrations yet.

Not claimed by G1: client/server launch, world load, rendering or gameplay correctness.
## G2 â€” Runtime skeleton
Status: **BLOCKED until executed**
- [PASS] dedicated server launches with exact IE dependency;
- [PENDING] client launches;
- [PENDING] baseline world copy loads without registry remap;
- [PASS] server log audit contains no Petroleum/IE classloading exception.

## G3 — Reservoir domain + storage
Status: **IN PROGRESS — G3A PASS / G3B pending**

### G3A — deterministic field, component identity and persistence
Decision: **PASS**
- pure reservoir arithmetic with SIMULATE/EXECUTE conservation;
- 1.21.1-derived V1 simplex field reconstructed and parity-tested;
- non-recursive bounded component scanner with canonical anchor identity;
- 512x512 per-dimension shards, matching modern RegionPos scale (`>>9`);
- versioned NBT codecs and mutable-state/type separation;
- dedicated-server persistence campaign: write -> restart -> mutate -> restart;
- corrupted-GZIP campaign returns UNREADABLE and does not modify the source file;
- post-corruption restored shard reloads successfully.

### G3B — type registry and deterministic genesis
Decision: **PENDING**
- reservoir type definitions and weighted registry;
- exact dimension/biome filtering policy;
- deterministic type/capacity selection from stable identity;
- oil/aquifer/lava defaults derived from frozen 1.21.1 recipes;
- no generation-order dependence;
- service API from world coordinate -> canonical ReservoirRecord.

## G4 â€” Pumpjack vertical slice
Status: **PLANNED**
- formation + break rollback;
- energy input and crude-oil output;
- server-authoritative reservoir depletion;
- 1.12/1.21-derived linked armature animation;
- premium renderer with correct bounds/culling;
- Angelica smoke/performance matrix.

## G5 â€” Distillation Tower
Status: **PLANNED**
- recipe transaction engine;
- crude oil input -> verified modern outputs;
- fluid/item output backpressure;
- static high-detail geometry with minimal dynamic layers;
- GUI + NEI/CraftTweaker integration only after core transaction passes.
## G6 â€” Modern extraction expansion
Status: **PLANNED**
- Derrick semantics and GUI/settings;
- Seismic Survey workflow and result synchronization;
- Oil Tank multiblock;
- migration policy for reservoir algorithm versioning.

## G7 â€” Modern processing expansion
Status: **PLANNED**
- Coker Unit and its recipe/process semantics;
- Gas Generator;
- Lubricant system + audited IE machine handlers;
- Auto Lubricator and Oil Can.

## G8 â€” Mobility / construction UX
Status: **PLANNED**
- Motorboat/Speedboat behavior selected from audited generations;
- Projector/ghost structure visualization;
- Asphalt family;
- networking abuse validation for vehicle/projector packets.

## G9 â€” Compatibility matrix
Status: **PLANNED**
Exact-pack tests for EnderIO, BuildCraft, Thermal, Mekanism, MFR, NEI, CraftTweaker, Angelica, GTNHLib and relevant IE integrations. Optional dependencies must be absent-testable unless explicitly declared required.

## G10 â€” Performance / soak / corruption campaign
Status: **PLANNED**
Synthetic matrices: 1/16/64/256 machines, depleted/full reservoirs, chunk-border multiblocks, repeated unload/reload, forced packet reorder/duplicate where harness permits, malformed NBT fixtures, and long-run conservation counters.

## G11 â€” Release candidate
Status: **BLOCKED**
Requires all feature gates selected for release, public-asset/license clearance or clean-room assets, reproducible clean build, compatibility report, SHA-256 manifest, known-issues register and upgrade/rollback documentation.

