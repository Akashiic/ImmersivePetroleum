# G5 Distillation Tower Evidence

Status: **ACCEPTED for 0.1.0-alpha.8 core gate**

## Scope accepted

This gate accepts the Distillation Tower transaction/runtime core, exact modern template mapping, Forge 1.7.10 ports, save/restart behavior and transactional formation/disassembly.

It does **not** claim the premium renderer/final art, GUI/NEI/CraftTweaker integration or complete pack compatibility matrix.

## Pure transaction evidence

The G5 pure suite covers:

- current oil and kerosene recipe data;
- current queue/admission/backpressure ordering;
- integer `energyPerTick` scheduler parity;
- current byproduct RNG call ordering, including the discarded preflight roll;
- input/output capacities and aggregate multi-fluid output accounting;
- clean and adversarial energy commit/rollback;
- input mutation and output backpressure;
- recipe removal/tick validation for persisted process state.

A separate randomized audit executes 250,000 generated recipe scenarios with 1-12 process ticks, 1-4 output fluids, varied energy totals, preloaded tanks and residual input. Accounting invariants require exact recipe input debit, exact output credits and exact integer per-tick energy consumption.

Pre-freeze full build result:

- 156 tests;
- 0 failures;
- 0 errors;
- 40 tests in the Distillation package;
- Checkstyle main: 0 errors;
- Checkstyle test: 0 errors.

## Template evidence

Frozen `distillationtower.nbt` SHA-256:

`f1a33208203e6daeead34e16e306b34856fbd6c11613cb8f3ed4245d0e500442`

The deterministic generator rejects unexpected size, palette/material counts, duplicate positions or entry count before writing Java. Generated entry count is 137.

A separate symmetry/orientation audit proves unique formation for all 8 combinations of N/E/S/W x mirrored/unmirrored and explicitly asserts `toWorld(MASTER) == worldMaster`.

## Dedicated-server foundation gate

`DistillationFoundationProbe` verifies under real Forge/FML lifecycle:

- Petroleum bitumen item registration;
- Petroleum grated steel compatibility slab registration;
- exact IE 0.7.9 material/metas used by the 137-block template;
- top/bottom slab metadata behavior;
- reversible scaffolding/slab crafting;
- current required Petroleum fluid registrations and recipe-book aliases.

Accepted marker:

`DISTILLATION_FOUNDATION_PROBE_PASS blocks=1 items=1 template=137`

## Four-boot multiblock campaign

`run-distillation-multiblock-campaign.ps1` uses a fresh isolated world and validates:

1. `write`: place exact template, form 137 parts, validate ports, process crude oil, auto-output naphtha, redstone disable and save;
2. `verify-break`: restart, verify energy/input/output persistence and captured original pipe NBT, then break and restore the structure;
3. `verify-reform`: restart disassembled state, verify restored blocks/NBT, then reform;
4. `orientation-matrix`: independently form/break all eight facing/mirror combinations and require zero ghost formed TileEntities.

Two complete campaigns were then run consecutively under the shared runtime-probe mutex and both emitted:

`DISTILLATION_MULTIBLOCK_CAMPAIGN_PASS`

The second accepted campaign produced region SHA-256:

`5e18a6c8b434d4a066664c2aaacb1dae76fe60517f9295f7beca571a3e0fb856`

The Anvil-region hash is diagnostic rather than a cross-version golden artifact; semantic PASS markers and state assertions are the acceptance criteria.

## Rejected / repaired evidence

Two defects were caught before freeze:

- the first generated transform incorrectly inherited the Pumpjack assumption that master local Z was zero; Distillation master is `(2,0,2)`. Runtime formation exposed the displacement. Generator, symmetry audit and tests were corrected to subtract all master axes;
- shared runtime campaigns could run concurrently from separate chats and mutate the same `run/server.properties`/worlds. This produced an intermittent false `verify-reform` failure. Process inspection proved another regression campaign/server was active concurrently. All runtime campaigns now use a shared named mutex, and the lock was tested to reject a concurrent campaign before any Gradle/Java child was spawned.

Neither rejected run is accepted as alpha.8 evidence.

## Regression evidence

After the Distillation changes, the previous gates were rerun and passed: Pumpjack multiblock, Pumpjack kernel, Well/WellPipe, fluid registry normal+collision, reservoir genesis, and persistence/corruption/recovery.

## Alpha.8 final validation

After bumping source/metadata to `0.1.0-alpha.8`:

- `gradlew clean check build --no-daemon`: PASS, 26 tasks;
- 156 tests / 0 failures / 0 errors;
- 40 Distillation tests;
- Checkstyle main/test: 0 errors;
- `DISTILLATION_FOUNDATION_CAMPAIGN_PASS`;
- `DISTILLATION_MULTIBLOCK_CAMPAIGN_PASS` across write, verify-break, verify-reform and orientation-matrix boots;
- final post-RNG-fix multiblock region SHA-256: `00b6dbb491bf0d33f138f810f8ebc26d00fdb590819661f0b0fb5a4b76c15753`.

The previous six runtime gates were also rerun successfully before the alpha.8 freeze: Pumpjack multiblock/kernel, Well infrastructure, fluid registry normal+collision, reservoir genesis, and persistence/corruption/recovery.
