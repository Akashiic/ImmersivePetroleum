# G4B2C Evidence - Pumpjack multiblock state

Decision: **PASS** for `0.1.0-alpha.6`
Date: 2026-09-11

## Exact semantic sources
Frozen TwistedGate Immersive Petroleum 1.21.1:
- `PumpjackMultiblock.java` / `pumpjack.nbt`;
- `PumpjackLogic.java`;
- `WellTileEntity.java` / `WellPipeTileEntity.java`.

Target runtime:
- Forbidden IE 0.7.9 `TileEntityMultiblockPart` and `MultiblockHandler.IMultiblock`;
- Forge 10.13.4.1614 Block/TileEntity lifecycle;
- CoFH EnergyStorage and Forge IFluidHandler.

## Automated evidence
Current clean/incremental suite before release freeze: **106 tests / 0 failures / 0 errors**.
`tools/run-pumpjack-multiblock-campaign.ps1` performs four dedicated-server boots:
1. `write`: form the 32-block machine, preserve custom IE pipe NBT, connect completed Well/output network, run two Pumpjack ticks, verify 30 mB / 2048 RF and one tap-cache build;
2. `verify-break`: restart formed machine, verify persisted energy/output/NBT, break trigger and require clean disassembly;
3. `verify-reform`: restart disassembled structure, restore trigger, reform and revalidate captured component NBT;
4. `orientation-matrix`: form/break all N/E/S/W × mirrored/unmirrored cases.

Accepted marker: `PUMPJACK_MULTIBLOCK_CAMPAIGN_PASS`.
Accepted execution-region evidence SHA-256 for this campaign: `27d66284acec97906b8913e3a130f8e5a51a5f124ac9918f773ec8c1dd7703cc`.

The Anvil hash is evidence of this run, not a semantic invariant; probe assertions and markers decide the gate.
## Runtime behavior proven
- master survives restart and retains energy;
- completed Well remains connected through vertical WellPipe;
- two steady-state ticks transfer exactly 15 mB each and consume 1024 RF each;
- reservoir discovery cache builds once across the two ticks;
- redstone signal disables without energy/fluid/source mutation;
- fake formed fluid ports expose only the expected outward faces;
- energy input exposes UP only;
- breaking a formed part leaves no ghost Pumpjack TileEntities;
- custom original IE FluidPipe `sideConfig` and colour survive form → restart → disassemble → restart → reform.

## Regression closure before alpha.6 candidate
- G4B2B Well infrastructure 3-JVM campaign: PASS;
- G4B1 Pumpjack kernel campaign: PASS;
- G4A fluid registry normal+collision campaign: PASS; temporary fixture absent afterward;
- G3B deterministic genesis campaign: PASS with canonical anchor/capacity/shard hash unchanged;
- G3A five-boot persistence/corruption/recovery campaign: PASS with canonical valid/corrupt hashes unchanged.

## Final alpha.6 freeze
- clean check build --no-daemon: PASS, 26 tasks;
- JUnit: **106 tests / 0 failures / 0 errors**;
- Java class major 52;
- candidate JAR contains zero collision-fixture entries;
- post-version Pumpjack multiblock campaign: PASS across write/break/reform/orientation boots;
- G4B2B/G4B1/G4A/G3B/G3A regression campaigns: PASS before freeze.
