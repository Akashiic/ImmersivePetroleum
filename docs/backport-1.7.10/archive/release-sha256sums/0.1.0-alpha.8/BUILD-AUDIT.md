# Immersive Petroleum 1.7.10 - alpha.8 Build Audit

Freeze: `759d3a5` / tag `0.1.0-alpha.8`
Target: Minecraft 1.7.10 / Forge 10.13.4.1614 / Java 8 bytecode
IE dependency: Forbidden `ImmersiveEngineering-garden-cloche-test-2.jar`

## Artifact
- `immersivepetroleum-0.1.0-alpha.8.jar`
- bytes: 284913
- SHA-256: `054859cefb627730e2754a7ba70bb6a64b1bc4f0dfb395032070cb6a46e7815c`
- class major version: 52
- embedded Angelica/GTNHLib/UniMixins classes: 0
- fixture entries: 0

## Static gates
- clean `check build`: PASS, 26 tasks / 25 executed
- JUnit: 156 tests / 0 failures / 0 errors
- Checkstyle main/test: 0 errors

## G5 Distillation Tower core
- modern recipe semantics and integer energy/tick parity: PASS
- 250,000-scenario randomized accounting campaign: PASS
- frozen 1.21.1 NBT template: 4x16x4 / 137 blocks / SHA-256 anchored: PASS
- dedicated foundation probe: bitumen, grated slab compatibility, recipes, mappings: PASS
- formation/process/auto-output/persistence/break/reform: PASS
- orientation matrix N/S/E/W x mirrored/unmirrored: PASS
- two consecutive isolated four-boot campaigns: PASS
- runtime campaign mutex prevents concurrent probe contamination: PASS

## Previous regression gates
Pumpjack multiblock/kernel, Well/WellPipe, fluid registry normal+collision, reservoir genesis and persistence/corruption/recovery all passed on the G5 source before freeze.

## Scope note
Alpha.8 approves the Distillation Tower gameplay/core foundation. Premium formed rendering, final production art and Angelica visual certification for the Distillation Tower remain a subsequent renderer gate.