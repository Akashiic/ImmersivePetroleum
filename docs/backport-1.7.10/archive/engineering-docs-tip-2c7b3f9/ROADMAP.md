# Engineering Roadmap / Approval Gates

## Gate state legend
- `PASS`: evidence satisfies current exit criteria.
- `FAIL`: a concrete defect blocks advancement.
- `BLOCKED`: prerequisite gate is incomplete.
- `PLANNED`: not yet executed.

## G0 - Evidence and workspace freeze
Current status: **PASS**

Exit evidence:
- actual Forbidden Series mod directory inventoried: 161 files / 161 hashes / 0 null hashes;
- exact current IE development dependency frozen by SHA-256;
- upstream 1.21.1, 1.12.2 and legacy master cloned separately with commit IDs recorded;
- no production modpack JAR modified;
- independent Git/RFG workspace created.

Audit incident: first hash pass omitted eight JARs whose names contain square brackets because PowerShell wildcard semantics were used. That run was REJECTED. The collector was corrected to `-LiteralPath` and the complete 161/161 snapshot replaced it.

## G1 - Reproducible skeleton build
Current status: **PASS (compile/reobf only)**

Evidence:
- `gradlew clean build --stacktrace`: exit code 0;
- `compileJava`, `check`, `jar`, `reobfJar` and `build` completed;
- generated production class major version = 52 (Java 8);
- minimal addon depends on `ImmersiveEngineering` and has no gameplay registrations yet.

Not claimed by G1: client/server launch, world load, rendering or gameplay correctness.
## G2 - Runtime skeleton
Status: **PARTIAL - client/server smoke passed; copied production world pending**
- [PASS] dedicated server launches with exact IE dependency;
- [PASS] client launches with Angelica (alpha.7 and alpha.9 evidence);
- [PENDING] baseline world copy loads without registry remap;
- [PASS] server log audit contains no Petroleum/IE classloading exception.

## G3 - Reservoir domain + storage
Status: **PASS — G3A PASS / G3B PASS**

### G3A - deterministic field, component identity and persistence
Decision: **PASS**
- pure reservoir arithmetic with SIMULATE/EXECUTE conservation;
- 1.21.1-derived V1 simplex field reconstructed and parity-tested;
- non-recursive bounded component scanner with canonical anchor identity;
- 512x512 per-dimension shards, matching modern RegionPos scale (`>>9`);
- versioned NBT codecs and mutable-state/type separation;
- dedicated-server persistence campaign: write -> restart -> mutate -> restart;
- corrupted-GZIP campaign returns UNREADABLE and does not modify the source file;
- post-corruption restored shard reloads successfully.

### G3B - type registry and deterministic genesis
Decision: **PASS**
- reservoir type definitions and weighted registry;
- exact dimension/biome filtering policy;
- deterministic type/capacity selection from stable identity;
- oil/aquifer/lava defaults derived from frozen 1.21.1 recipes;
- no generation-order dependence;
- service API from world coordinate -> canonical ReservoirRecord.

## G4 - Industrial Foundation / Pumpjack vertical slice
Status: **IN PROGRESS - G4A PASS / G4B1 PASS / G4B2A PASS / G4B2B PASS / G4B2C PASS / G4B3A PASS / G4B3B PLANNED**

### G4A - fluid registry and reservoir binding
Decision: **PASS**
- 10 current-generation Petroleum fluids registered through Forge 1.7.10 FluidRegistry;
- physical values transcribed from frozen 1.21.1 IPContent;
- canonical owner ids verified as `immersivepetroleum:<name>`;
- reservoir oil/aquifer/lava bindings verified at dedicated-server lifecycle;
- foreign `crudeoil` default collision tested with an injected fixture;
- gameplay FluidStacks use the effective Forge global default, never an unverified candidate delegate;
- repeated `registerAll()` is idempotent;
- no upstream fluid textures or placeable Petroleum fluid blocks are shipped in G4A.

### G4B1 - Pumpjack transaction kernel
Decision: **PASS**
- modern 1.21.1 semantics selected over the legacy 1.12 extraction loop;
- Pumpjack blocks while any tapped finite reservoir still has pressure;
- default cost/throughput preserved at 1024 Flux/t and 15 mB/t per finite tap;
- finite output is EAST -> WEST with reservation + exact rollback of unaccepted volume;
- infinite reservoirs preserve independent full-flow offers per port with up to 10 output attempts;
- internal CoFH energy is reserved transactionally and restored when no fluid/uncertain side effect occurred;
- protocol-violating sources/outputs fail closed; untrusted source returns are never used to restore fluid;
- 250k randomized finite-conservation campaign plus adversarial unit tests;
- dedicated-server probe covers real ReservoirRecord, EnergyStorage, FluidRegistry and IFluidHandler adapters.

### G4B2A - Well domain and persistence
Decision: **PASS**
- current-generation Well pipe budget/progress/topology semantics;
- ordered duplicate tapped columns preserved;
- schema-v1 fail-closed NBT with future/corrupt-state quarantine;
- topology becomes immutable once drilling begins.

### G4B2B - Well/WellPipe Forge infrastructure
Decision: **PASS**
- hidden Well and WellPipe blocks registered without ItemBlock or loot;
- persisted TileEntity Well + lightweight vertical WellPipe connector;
- physical pipe break rollback and missing-segment connection termination;
- dedicated three-boot save/reload/mutate/self-destruct campaign.

### G4B2C - Pumpjack machine state / multiblock
Decision: **PASS**
- exact 32-block current-generation template mapped to IE 0.7.9 materials;
- transactional formation, original TileEntity NBT snapshots and deterministic disassembly;
- CoFH energy input, two Forge fluid outputs and redstone control;
- Well tap resolution cached outside the tick hot path and invalidated by topology revision;
- three-JVM form/restart/break/reform campaign plus 8-orientation matrix.

### G4B3A - clean-room renderer foundation
Decision: **PASS**
- exact upstream animation cadence with clean-room rigid four-bar kinematics;
- one master TESR, zero render-distance dispatch for 31 non-master parts;
- ~696 vertices / 174 quads per visible Pumpjack frame;
- whole-machine render envelope and orientation/mirror coverage;
- dedicated-server client-class isolation;
- real Angelica 2.2.8 / GTNHLib 0.11.41 / UniMixins 0.3.1 client smoke;
- 37-draw GL probe with zero post-render GL error and cull-state restoration;
- accepted side-profile screenshot evidence.

### G4B3B - final visual fidelity / shader certification
Decision: **PLANNED**
- independently-created premium production textures/models and final art pass;
- active shaderpack validation in addition to Angelica shaders-off path;
- final LOD/cache policy only if profiling proves it beneficial;
- no protected upstream Petroleum art enters a public package without clearance.
## G5 - Distillation Tower
Status: **IN PROGRESS - G5A PASS / G5B PASS / G5C1 PASS / G5C2 PLANNED**

### G5A - transaction engine and Forge foundation
Decision: **PASS**
- modern 24,000 mB input/output tanks, 16,000 RF buffer and single-process queue semantics;
- current oil/kerosene recipe data and byproduct RNG call ordering;
- 250k randomized recipe/accounting campaign plus adversarial unit tests;
- bitumen registry item and clean-room grated-steel slab compatibility block;
- exact 137-block template generated from frozen 1.21.1 NBT SHA-256;
- dedicated lifecycle probe for materials, recipes, registry and crafting.

### G5B - multiblock runtime, persistence and ports
Decision: **PASS**
- transactional 137-part formation with original TileEntity NBT snapshots and deterministic rollback/disassembly;
- CoFH energy, Forge fill-only input, aggregate multi-fluid drain-only output and redstone control;
- schema-v1 fail-closed machine-state persistence with raw-NBT quarantine preservation;
- external auto-output reservation/rollback and uncertainty quarantine;
- two consecutive isolated four-boot campaigns: process/save, restart/break, restart/reform and 8-orientation matrix;
- global runtime-campaign mutex prevents cross-chat/shared-run harness interference.

### G5C1 - renderer foundation and Angelica validation
Decision: **PASS**
- clean-room procedural high-detail tower geometry with no copied Petroleum art;
- master-only TESR dispatch and conservative whole-tower culling envelope;
- real Angelica 2.2.8 GL matrix across facing/mirror/active states with cull restoration;
- deterministic in-world screenshot probe and dedicated-server classloading smoke.

### G5C2 - final refinery UX / visual fidelity
Decision: **PLANNED**
- independently-created production textures/material polish and final art pass;
- active third-party shaderpack certification and measured LOD/cache decision;
- GUI + NEI/CraftTweaker integration;
- final release balancing and refinery presentation.
## G6 - Modern extraction expansion
Status: **IN PROGRESS - Derrick G6A/G6B/G6C/G6D/G6E PASS subgates; premium/exploration expansion pending**
- Derrick default drilling/pressure, multiblock runtime, server container and renderer foundation accepted in alpha.10; [evidence](G6-EVIDENCE.md);
- covered-IE-pipe duplication prevented in Derrick, Pumpjack and Distillation, with four-boot regression campaigns for all three;
- Derrick directional grid editing, concrete survival acquisition, final art/sound and multiplayer qualification remain pending;
- Seismic Survey workflow and result synchronization;
- Oil Tank multiblock;
- migration policy for reservoir algorithm versioning.

## G7 - Modern processing expansion
Status: **PLANNED**
- Coker Unit and its recipe/process semantics;
- Hydrotreater and sulfur recovery, with complete modern fraction/material recipes;
- Gas Generator;
- Lubricant system + audited IE machine handlers;
- Auto Lubricator and Oil Can.
- Flarestack, fuel disposal and its bounded client effects.

## G8 - Mobility / construction UX
Status: **PLANNED**
- Motorboat/Speedboat behavior selected from audited generations;
- Projector/ghost structure visualization;
- Asphalt family;
- Petcoke/dust/block, paraffin wax/block, gasoline bottles and Molotov content;
- networking abuse validation for vehicle/projector packets.

## G9 - Compatibility matrix
Status: **PLANNED**
Exact-pack tests for EnderIO, BuildCraft, Thermal, Mekanism, MFR, NEI, CraftTweaker, Angelica, GTNHLib and relevant IE integrations. Optional dependencies must be absent-testable unless explicitly declared required.

## G10 - Performance / soak / corruption campaign
Status: **PLANNED**
Synthetic matrices: 1/16/64/256 machines, depleted/full reservoirs, chunk-border multiblocks, repeated unload/reload, forced packet reorder/duplicate where harness permits, malformed NBT fixtures, and long-run conservation counters.

## G11 - Release candidate
Status: **BLOCKED**
Requires all feature gates selected for release, public-asset/license clearance or clean-room assets, reproducible clean build, compatibility report, SHA-256 manifest, known-issues register and upgrade/rollback documentation.
