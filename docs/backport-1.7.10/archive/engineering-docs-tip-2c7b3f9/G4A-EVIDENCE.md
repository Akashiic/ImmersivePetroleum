# G4A Evidence - Industrial Fluid Foundation

Status: ACCEPTED for 0.1.0-alpha.3
Date: 2026-09-10

## Frozen upstream specification
The 1.21.1 `IPContent` at commit `e6cb01df32d4adfd096d49c02bb91e60fef56a15` declares:

| Fluid | Density | Viscosity | Extra modern behavior retained as metadata |
|---|---:|---:|---|
| crudeoil | 1000 | 2250 | motion 0.007, tick delay 20, entity slowdown 0.4 |
| diesel_sulfur | 789 | 1750 | default motion/tick/slowdown |
| diesel | 789 | 1750 | default motion/tick/slowdown |
| lubricant | 925 | 1000 | default motion/tick/slowdown |
| gasoline | 789 | 1200 | default motion/tick/slowdown |
| naphtha | 750 | 750 | default motion/tick/slowdown |
| benzol | 876 | 700 | default motion/tick/slowdown |
| petroleum_gas | 2 | 1 | default motion/tick/slowdown |
| kerosene | 810 | 900 | default motion/tick/slowdown |
| napalm | 1000 | 4000 | motion 0.0105, tick delay 10, slowdown 0.7 |

The default modern motion/tick/slowdown metadata used by `IPFluid.makeFluid` is `0.014 / 5 / 0.8`. These values are recorded for later world-fluid behavior; G4A does not yet introduce placeable Petroleum fluid blocks.

## Dedicated-server normal registry probe
Expected and observed before alpha.3 freeze:
- 10 candidates registered;
- 10 current defaults owned by Petroleum;
- 0 delegated defaults;
- oil -> `crudeoil` with `OWN_DEFAULT`;
- aquifer -> vanilla water with `EXACT_EXTERNAL_DEFAULT`;
- lava reservoir -> vanilla lava with `EXACT_EXTERNAL_DEFAULT`;
- `FluidRegistry.validateFluidRegistry()` passes;
- repeated `PetroleumFluids.registerAll()` preserves candidate references and count.

## Dedicated-server collision probe
The reproducible test harness temporarily injects a test-only FML mod ordered before Petroleum. It registers `crudeoil` first and proves ownership as `ipfluidcollisionfixture:crudeoil`.

Observed result:
- Petroleum still registers all 10 owned candidates;
- current defaults: 9 Petroleum / 1 delegated;
- oil binding returns `DELEGATED_DEFAULT`;
- the resulting gameplay `FluidStack` uses the foreign global `crudeoil` default;
- `FLUID_PROBE_PASS registered=10`;
- fixture source is removed from `src/main` in a `finally` block.

## Rejected evidence / repairs
1. The first `ReservoirFluidBinding.java` write accidentally duplicated the final class tail; compile failed and that revision was rejected.
2. The first binding JUnit attempted to initialize Forge `FluidRegistry` outside Minecraft bootstrap; `Blocks.water` was null. Those tests were rejected as invalid test-environment evidence.
3. The first collision runtime asserted that `FluidStack(candidate).getFluid()` must already equal the foreign global default. The dedicated fixture disproved this. Candidate-delegate stack construction was rejected and replaced by direct effective-default stack construction.
4. An earlier engineering note listed different fluid physical values. Direct inspection of the frozen 1.21.1 `IPContent` supersedes it; the table above is the accepted specification.

## Release boundary
G4A proves registry/binding infrastructure, not the Pumpjack. No machine block, extraction transaction, bucket, placeable Petroleum liquid block, upstream texture or 3D Petroleum asset is approved by this gate. Those remain later G4 gates.

## Alpha.3 final regression campaign
The version-candidate source was bumped to `0.1.0-alpha.3` before the final campaigns.

- clean `check build`: PASS;
- complete JUnit suite: **48 tests / 0 failures / 0 errors**;
- clean candidate JAR before runtime campaigns contained zero `FluidCollisionFixture` entries;
- normal fluid registry campaign: PASS (`10 own / 0 delegated`);
- collision fluid registry campaign: PASS (`9 own / 1 delegated`, oil `DELEGATED_DEFAULT`);
- G3B genesis regression: PASS, capacity `20,450,302 mB`, mutated amount `20,449,068 mB`, shard SHA-256 `afecf49cb33f6c401f43f881e143eda6449beb7177831a3ad40c7a3709a61edc`;
- G3A five-boot persistence/corruption regression: PASS, valid shard SHA-256 `9e9d4b16e2a6600d7ec9b1256c0c917ce60eeb0cdcf1ae402c8d4a2198ec76f5`, corrupt payload SHA-256 `a186a1cea95d58343c5b056b18fef1c750a1612ef955e08bf6b426a75d3ef141`.

After the collision campaign the fixture source is absent from `src/main`. A final clean build is mandatory before release artifact freeze so no stale fixture class can survive in Gradle output.