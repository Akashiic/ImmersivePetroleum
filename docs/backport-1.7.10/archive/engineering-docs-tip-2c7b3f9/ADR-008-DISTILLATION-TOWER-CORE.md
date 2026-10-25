# ADR-008 - Distillation Tower Core

Status: **ACCEPTED for 0.1.0-alpha.8 core gate**

## Decision

The 1.7.10 Distillation Tower is a separate transactional multiblock built from the frozen current-generation Petroleum semantics rather than a direct copy of the legacy 1.12 machine.

The machine uses a pure transaction engine for recipe admission/progress/completion and a Forge adapter layer for energy, fluids, item output, redstone, formation, persistence and external auto-output.

The visual renderer is explicitly outside this ADR. Alpha.8 freezes the core/runtime multiblock only.

## Frozen evidence

- Immersive Petroleum 1.21.1 source: `e6cb01df32d4adfd096d49c02bb91e60fef56a15`.
- Immersive Engineering 1.21.1 scheduler reference: `75a27f03e4243544243567e8d5c38d336f4f10f4`.
- Distillation template NBT SHA-256: `f1a33208203e6daeead34e16e306b34856fbd6c11613cb8f3ed4245d0e500442`.
- Target runtime: Forge 10.13.4.1614 + IE 0.7.9 Forbidden artifact.

## Modern machine semantics

- input tank: 24,000 mB;
- aggregate multi-fluid output tank: 24,000 mB;
- energy buffer: 16,000 RF;
- process queue size: one;
- `energyPerTick = totalProcessEnergy / totalProcessTime` using integer division, matching the modern IE scheduler;
- process admission occurs before output backpressure can pause progress;
- fluid input is consumed and outputs are materialized on process completion;
- item byproduct chance is rolled during process checks and again at completion, preserving current upstream behavior; runtime chance values come from the 1.7.10 World RNG, matching modern Level RNG ownership;
- redstone disables processing and automatic output;
- each output fraction may auto-push up to 100 mB per tick to the external handler.

Default frozen recipes include:

- oil: 60 mB crude -> 15 naphtha + 20 kerosene + 30 sulfur diesel + 10 lubricant, 1024 RF, time 1, 7% bitumen;
- kerosene: 10 mB kerosene -> 5 benzol + 5 sulfur diesel, 1024 RF, time 1.

## Structure and compatibility mapping

The Java structure table is generated deterministically from the frozen 1.21.1 NBT. It contains 137 blocks in a 4x16x4 envelope:

- 25 steel scaffolding;
- 4 heavy engineering;
- 1 redstone engineering;
- 60 iron sheetmetal;
- 30 top-half grated steel scaffolding slabs;
- 17 fluid pipes.

Master is `(2,0,2)` and trigger/redstone is `(0,1,3)`. Transform code is relative to the true master on all three axes; an earlier generator that implicitly assumed `master.z == 0` was rejected by the runtime probe and repaired before freeze.

IE 0.7.9 lacks the modern grated-scaffolding slab. Petroleum therefore registers a clean-room compatibility slab using the vanilla 1.7.10 slab top/bottom metadata contract. Material conversion preserves the modern net cost: one IE steel scaffolding <-> two grated slabs.

No upstream Petroleum texture is copied. The slab reuses the target IE scaffolding icon at runtime; bitumen has a Petroleum registry identity with a temporary safe fallback icon pending the final art gate.

## Safety and persistence

- formation snapshots all original blocks, metadata and TileEntity NBT before replacing any part;
- formation failure rolls back committed parts;
- disassembly restores original blocks and TileEntity NBT and leaves only the actually broken part absent;
- machine-state NBT uses schema v1 and validates queued recipe id/tick on load;
- undecodable machine state is quarantined and its raw NBT is preserved instead of being overwritten by an empty state;
- external fluid push reserves internal volume before execute, restores only provably unaccepted volume, and quarantines uncertain protocol side effects;
- energy uses reversible CoFH storage accounting;
- output tank capacity is aggregate across all fractions, not 24,000 mB per fluid.

## Runtime-harness isolation

All long-running runtime campaigns now share a named Windows mutex, `Global\ImmersivePetroleumRuntimeProbe`. This was added after concurrent campaign processes were proven to contaminate the shared `run/server.properties`/world harness and produce a false intermittent reformation failure.

The mutex was verified by holding it in one process and requiring a second campaign to abort before spawning Gradle/Java. After isolation, the complete Distillation campaign passed twice consecutively.

## Deferred work

- premium Distillation Tower renderer and final original art;
- active-shader visual certification;
- GUI/NEI/CraftTweaker integration;
- full BuildCraft/Thermal/etc. compatibility matrix for historical `oil` aliases;
- release balancing and long soak testing.
